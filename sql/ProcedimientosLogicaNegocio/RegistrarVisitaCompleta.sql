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
Permite registrar una visita médica para un paciente y un médico, asociada a una cita existente, almacenando signos vitales, motivo, diagnóstico y plan de tratamiento. Valida la existencia de la cita, paciente y médico, el estado de la cita, la obligatoriedad de los campos principales y las restricciones de formato y rango para los datos clínicos.

Parámetros:
@ID_Cita           - (Requerido) Identificador único de la cita (entero positivo)
@ID_Paciente       - (Requerido) Identificador único del paciente (entero positivo)
@ID_Medico         - (Requerido) Identificador único del médico (entero positivo)
@Talla             - Talla del paciente en cm (decimal, opcional, 30.00 a 250.00)
@Peso              - Peso del paciente en kg (decimal, opcional, 1.00 a 350.00)
@Tension_Arterial  - Tensión arterial (texto, opcional, máx 20 caracteres)
@Pulso             - Pulso cardíaco (entero, opcional, 20 a 250)
@Spo2              - Saturación de oxígeno (entero, opcional, 50 a 100)
@Temperatura       - Temperatura corporal (decimal, opcional, 30.00 a 45.00)
@Motivo_Consulta   - (Requerido) Motivo de la consulta (texto, no vacío)
@Examen_Fisico     - Examen físico realizado (texto, opcional)
@Diagnostico       - (Requerido) Diagnóstico médico (texto, no vacío)
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
-6   - Valor fuera de rango o formato inválido en datos clínicos
-98  - No se pudo actualizar el estado de la cita
-99  - Error de sistema

Ejemplo de uso:
DECLARE @ID_Visita INT, @Mensaje NVARCHAR(255);

-- Caso exitoso (todos los parámetros válidos, cita programada para Elena Morales con el Dr. Carlos Rivera)
EXEC RegistrarVisitaCompleta
    @ID_Cita = 1, -- Cita programada para Elena Morales (ID_Paciente=1) y Carlos Rivera (ID_Medico=1)
    @ID_Paciente = 1,
    @ID_Medico = 1,
    @Talla = 160.0,
    @Peso = 65.5,
    @Tension_Arterial = N'120/80',
    @Pulso = 75,
    @Spo2 = 98,
    @Temperatura = 36.8,
    @Motivo_Consulta = N'Chequeo general anual.',
    @Examen_Fisico = N'Paciente afebril, consciente, orientada.',
    @Diagnostico = N'Paciente sana, control de rutina.',
    @Plan_Tratamiento = N'Continuar estilo de vida saludable.',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

-- Caso: Cita no existe (ID_Cita no registrado)
EXEC RegistrarVisitaCompleta
    @ID_Cita = 9999,
    @ID_Paciente = 1,
    @ID_Medico = 1,
    @Motivo_Consulta = N'Consulta',
    @Diagnostico = N'Diagnóstico',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

-- Caso: Paciente no existe
EXEC RegistrarVisitaCompleta
    @ID_Cita = 1,
    @ID_Paciente = 9999,
    @ID_Medico = 1,
    @Motivo_Consulta = N'Consulta',
    @Diagnostico = N'Diagnóstico',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

-- Caso: Médico no existe
EXEC RegistrarVisitaCompleta
    @ID_Cita = 1,
    @ID_Paciente = 1,
    @ID_Medico = 9999,
    @Motivo_Consulta = N'Consulta',
    @Diagnostico = N'Diagnóstico',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

-- Caso: Estado de cita inválido (cita ya realizada o cancelada, ejemplo: ID_Cita=4 o 5)
EXEC RegistrarVisitaCompleta
    @ID_Cita = 4, -- Cita ya realizada
    @ID_Paciente = 1,
    @ID_Medico = 2,
    @Motivo_Consulta = N'Consulta',
    @Diagnostico = N'Diagnóstico',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

EXEC RegistrarVisitaCompleta
    @ID_Cita = 5, -- Cita cancelada
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

-- Caso: Valor fuera de rango (ejemplo: talla muy baja)
EXEC RegistrarVisitaCompleta
    @ID_Cita = 3,
    @ID_Paciente = 3,
    @ID_Medico = 5,
    @Talla = 10.0, -- fuera de rango
    @Peso = 14.0,
    @Tension_Arterial = N'90/60',
    @Pulso = 110,
    @Spo2 = 99,
    @Temperatura = 37.5,
    @Motivo_Consulta = N'Control de niño sano',
    @Diagnostico = N'Niña sana',
    @OUT_ID_Visita = @ID_Visita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

Notas:
- La cita debe existir y estar asociada al paciente y médico indicados.
- Solo se permite registrar la visita si la cita está en estado 'Programada' o 'Confirmada'.
- Motivo de consulta y diagnóstico son obligatorios y no pueden estar vacíos.
- Los valores clínicos opcionales, si se envían, deben cumplir con los rangos y formatos definidos.
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

    -- Validaciones de existencia
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

    -- Validar estado de la cita
    DECLARE @EstadoCitaActual NVARCHAR(50);
    SELECT @EstadoCitaActual = Estado_Cita FROM Cita WHERE ID_Cita = @ID_Cita;

    IF @EstadoCitaActual NOT IN ('Programada', 'Confirmada')
    BEGIN
        SET @OUT_Mensaje = 'Error: La cita ID ' + CAST(@ID_Cita AS NVARCHAR) + ' no está en un estado válido para registrar una visita (Estado actual: ' + @EstadoCitaActual + ').';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -4;
    END

    -- Validar campos obligatorios
    IF LTRIM(RTRIM(ISNULL(@Motivo_Consulta, ''))) = '' OR LTRIM(RTRIM(ISNULL(@Diagnostico, ''))) = ''
    BEGIN
        SET @OUT_Mensaje = 'Error: El motivo de consulta y el diagnóstico son obligatorios para registrar la visita.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -5;
    END

    -- Validar rangos y formatos de datos clínicos opcionales
    IF @Talla IS NOT NULL AND (@Talla < 30 OR @Talla > 250)
    BEGIN
        SET @OUT_Mensaje = 'Error: El valor de talla debe estar entre 30 y 250 cm.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -6;
    END
    IF @Peso IS NOT NULL AND (@Peso < 1 OR @Peso > 350)
    BEGIN
        SET @OUT_Mensaje = 'Error: El valor de peso debe estar entre 1 y 350 kg.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -6;
    END
    IF @Tension_Arterial IS NOT NULL AND LEN(@Tension_Arterial) > 20
    BEGIN
        SET @OUT_Mensaje = 'Error: La tensión arterial no debe exceder 20 caracteres.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -6;
    END
    IF @Pulso IS NOT NULL AND (@Pulso < 20 OR @Pulso > 250)
    BEGIN
        SET @OUT_Mensaje = 'Error: El pulso debe estar entre 20 y 250.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -6;
    END
    IF @Spo2 IS NOT NULL AND (@Spo2 < 50 OR @Spo2 > 100)
    BEGIN
        SET @OUT_Mensaje = 'Error: El valor de SpO2 debe estar entre 50 y 100.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -6;
    END
    IF @Temperatura IS NOT NULL AND (@Temperatura < 30 OR @Temperatura > 45)
    BEGIN
        SET @OUT_Mensaje = 'Error: La temperatura debe estar entre 30.00 y 45.00 °C.';
        SET @OUT_ID_Visita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -6;
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