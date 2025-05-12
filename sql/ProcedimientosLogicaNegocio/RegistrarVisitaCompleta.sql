PRINT 'Creando procedimiento RegistrarVisitaCompleta...';
GO

/* ======================================================================
Nombre: RegistrarVisitaCompleta
Propósito: Registra una visita médica completa asociada a una cita, paciente y médico, validando exhaustivamente los datos de entrada.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Permite registrar una visita médica para un paciente y un médico, asociada a una cita existente, almacenando signos vitales, motivo, diagnóstico y plan de tratamiento. Valida la existencia de la cita, paciente y médico, el estado de la cita y la obligatoriedad de los campos principales.

Parámetros:
@ID_Cita           - (Requerido) Identificador único de la cita (entero positivo)
@ID_Paciente       - (Requerido) Identificador único del paciente (entero positivo)
@ID_Medico         - (Requerido) Identificador único del médico (entero positivo)
@Talla             - Talla del paciente en cm (decimal, opcional)
@Peso              - Peso del paciente en kg (decimal, opcional)
@Tension_Arterial  - Tensión arterial (texto, opcional)
@Pulso             - Pulso cardíaco (entero, opcional)
@Spo2              - Saturación de oxígeno (entero, opcional)
@Temperatura       - Temperatura corporal (decimal, opcional)
@Motivo_Consulta   - (Requerido) Motivo de la consulta (texto)
@Examen_Fisico     - Examen físico realizado (texto, opcional)
@Diagnostico       - (Requerido) Diagnóstico médico (texto)
@Plan_Tratamiento  - Plan de tratamiento (texto, opcional)
@OUT_ID_Visita     - (Salida) ID de la visita médica creada (entero)
@OUT_Mensaje       - (Salida) Mensaje descriptivo del resultado (texto)

Códigos de Retorno:
 0   - Visita registrada exitosamente
-1   - La cita no existe para el paciente y médico especificados
-2   - Paciente no existe
-3   - Médico no existe
-4   - Estado de cita no válido para registrar visita
-5   - Motivo de consulta o diagnóstico vacío
-98  - No se pudo actualizar el estado de la cita
-99  - Error de sistema

Ejemplo de uso:
DECLARE @ID_Visita INT, @Mensaje NVARCHAR(255);
EXEC RegistrarVisitaCompleta
    @ID_Cita = 8,
    @ID_Paciente = 3,
    @ID_Medico = 5,
    @Motivo_Consulta = N'Control de presión arterial',
    @Diagnostico = N'Hipertensión controlada',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

-- Caso: Cita no existe
EXEC RegistrarVisitaCompleta
    @ID_Cita = 9999,
    @ID_Paciente = 1,
    @ID_Medico = 2,
    @Motivo_Consulta = N'Consulta',
    @Diagnostico = N'Diagnóstico',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

-- Caso: Paciente no existe
EXEC RegistrarVisitaCompleta
    @ID_Cita = 10,
    @ID_Paciente = 9999,
    @ID_Medico = 2,
    @Motivo_Consulta = N'Consulta',
    @Diagnostico = N'Diagnóstico',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

-- Caso: Estado de cita inválido
-- (Cambie el estado de la cita a un valor distinto de 'Programada' o 'Confirmada' antes de ejecutar)
EXEC RegistrarVisitaCompleta
    @ID_Cita = 10,
    @ID_Paciente = 2,
    @ID_Medico = 1,
    @Motivo_Consulta = N'Consulta',
    @Diagnostico = N'Diagnóstico',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

-- Caso: Motivo o diagnóstico vacío
EXEC RegistrarVisitaCompleta
    @ID_Cita = 2,
    @ID_Paciente = 2,
    @ID_Medico = 2,
    @Motivo_Consulta = N'',
    @Diagnostico = N'',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

Notas:
- La cita debe existir y estar asociada al paciente y médico indicados.
- Solo se permite registrar la visita si la cita está en estado 'Programada' o 'Confirmada'.
- Motivo de consulta y diagnóstico son obligatorios.
- El mensaje de salida (@OUT_Mensaje) describe el resultado o el error.
======================================================================= */

CREATE PROCEDURE RegistrarVisitaCompleta (
    @ID_Cita INT,
    @ID_Paciente INT,
    @ID_Medico INT,
    -- Campos de Visita_Medica
    @Talla DECIMAL(5,2) = NULL,
    @Peso DECIMAL(5,2) = NULL,
    @Tension_Arterial NVARCHAR(20) = NULL,
    @Pulso INT = NULL,
    @Spo2 INT = NULL,
    @Temperatura DECIMAL(4,2) = NULL,
    @Motivo_Consulta NVARCHAR(MAX),
    @Examen_Fisico NVARCHAR(MAX) = NULL,
    @Diagnostico NVARCHAR(MAX),
    @Plan_Tratamiento NVARCHAR(MAX) = NULL,
    -- Parámetros de salida
    @OUT_ID_Visita INT OUTPUT,
    @OUT_Mensaje NVARCHAR(255) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @FechaActual DATETIME = GETDATE();

    -- Validaciones básicas
    IF NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita AND ID_Paciente = @ID_Paciente AND ID_Medico = @ID_Medico)
    BEGIN
        SET @OUT_Mensaje = 'Error: La cita ID ' + CAST(@ID_Cita AS NVARCHAR) + ' no existe para el paciente y médico especificados.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -1;
    END

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        SET @OUT_Mensaje = 'Error: El paciente con ID ' + CAST(@ID_Paciente AS NVARCHAR) + ' no existe.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -2;
    END

    IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
    BEGIN
        SET @OUT_Mensaje = 'Error: El médico con ID ' + CAST(@ID_Medico AS NVARCHAR) + ' no existe.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -3;
    END

    DECLARE @EstadoCitaActual NVARCHAR(50);
    SELECT @EstadoCitaActual = Estado_Cita FROM Cita WHERE ID_Cita = @ID_Cita;

    IF @EstadoCitaActual NOT IN ('Programada', 'Confirmada')
    BEGIN
        SET @OUT_Mensaje = 'Error: La cita ID ' + CAST(@ID_Cita AS NVARCHAR) + ' no está en un estado válido para registrar una visita (Estado actual: ' + @EstadoCitaActual + ').';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -4;
    END
    
    IF LTRIM(RTRIM(ISNULL(@Motivo_Consulta, ''))) = '' OR LTRIM(RTRIM(ISNULL(@Diagnostico, ''))) = ''
    BEGIN
        SET @OUT_Mensaje = 'Error: El motivo de consulta y el diagnóstico son obligatorios para registrar la visita.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -5;
    END

    BEGIN TRANSACTION;

    BEGIN TRY
        -- 1. Insertar la visita médica
        INSERT INTO Visita_Medica (
            ID_Paciente, ID_Medico, ID_Cita, Fecha_Visita,
            Talla, Peso, Tension_Arterial, Pulso, Spo2, Temperatura,
            Motivo_Consulta, Examen_Fisico, Diagnostico, Plan_Tratamiento
        )
        VALUES (
            @ID_Paciente, @ID_Medico, @ID_Cita, @FechaActual,
            @Talla, @Peso, @Tension_Arterial, @Pulso, @Spo2, @Temperatura,
            @Motivo_Consulta, @Examen_Fisico, @Diagnostico, @Plan_Tratamiento
        );

        SET @OUT_ID_Visita = SCOPE_IDENTITY();

        -- 2. Actualizar el estado de la cita a 'Realizada'
        UPDATE Cita
        SET Estado_Cita = 'Realizada'
        WHERE ID_Cita = @ID_Cita;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @OUT_Mensaje = 'Error: No se pudo actualizar el estado de la cita ID ' + CAST(@ID_Cita AS NVARCHAR) + ' a "Realizada".';
            SET @OUT_ID_Visita = NULL;
            ROLLBACK TRANSACTION;
            RAISERROR(@OUT_Mensaje, 16, 1);
            RETURN -98;
        END

        COMMIT TRANSACTION;

        SET @OUT_Mensaje = 'Visita médica registrada exitosamente.';
        RETURN 0;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @OUT_Mensaje = 'Error SQL al registrar la visita: ' + ERROR_MESSAGE();
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -99;
    END CATCH
END;
GO

PRINT 'Procedimiento RegistrarVisitaCompleta creado.';