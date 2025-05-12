PRINT 'Creando procedimiento ProgramarCita...';
GO

/* ======================================================================
Nombre: ProgramarCitaManual
Propósito: Programa una nueva cita médica para un paciente con un médico específico, validando disponibilidad y datos de entrada.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Permite registrar una cita médica para un paciente con un médico en una fecha y hora específica, asegurando que no existan conflictos de agenda y que los datos sean válidos.

Parámetros:
@ID_Paciente             - (Requerido) Identificador único del paciente (entero positivo)
@ID_Medico_Seleccionado  - (Requerido) Identificador único del médico (entero positivo)
@Fecha_Hora_Cita         - (Requerido) Fecha y hora de la cita (formato DATETIME, debe ser futura)
@OUT_ID_Cita             - (Salida) ID de la cita creada (entero)
@OUT_Mensaje             - (Salida) Mensaje descriptivo del resultado (texto)

Códigos de Retorno:
 0   - Cita programada exitosamente
-1   - Paciente no existe
-2   - Médico no existe
-3   - Fecha/Hora inválida (no es futura)
-4   - Médico ocupado en ese horario
-99  - Error de sistema

Ejemplo de uso:
DECLARE @ID_Cita INT, @Mensaje NVARCHAR(255);
EXEC ProgramarCitaManual 
    @ID_Paciente = 1,
    @ID_Medico_Seleccionado = 2,
    @Fecha_Hora_Cita = '2025-06-01 10:00',
    @OUT_ID_Cita = @ID_Cita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

-- Caso: Paciente no existe
EXEC ProgramarCitaManual 
    @ID_Paciente = 9999,
    @ID_Medico_Seleccionado = 2,
    @Fecha_Hora_Cita = '2025-06-01 10:00',
    @OUT_ID_Cita = @ID_Cita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

-- Caso: Médico no existe
EXEC ProgramarCitaManual 
    @ID_Paciente = 1,
    @ID_Medico_Seleccionado = 9999,
    @Fecha_Hora_Cita = '2025-06-01 10:00',
    @OUT_ID_Cita = @ID_Cita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

-- Caso: Fecha pasada
EXEC ProgramarCitaManual 
    @ID_Paciente = 1,
    @ID_Medico_Seleccionado = 2,
    @Fecha_Hora_Cita = '2020-01-01 10:00',
    @OUT_ID_Cita = @ID_Cita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

-- Caso: Médico ocupado
-- (Asegúrese de que ya exista una cita para ese médico en esa fecha/hora)
EXEC ProgramarCitaManual 
    @ID_Paciente = 1,
    @ID_Medico_Seleccionado = 2,
    @Fecha_Hora_Cita = '2025-06-01 10:00',
    @OUT_ID_Cita = @ID_Cita OUTPUT,
    @OUT_Mensaje = @Mensaje OUTPUT;

Notas:
- El procedimiento valida existencia de paciente y médico, que la fecha/hora sea futura y que el médico esté disponible.
- Si ocurre un error, @OUT_Mensaje describe el motivo.
======================================================================= */

CREATE PROCEDURE ProgramarCitaManual (
    @ID_Paciente INT,
    @ID_Medico_Seleccionado INT,
    @Fecha_Hora_Cita DATETIME,
    @OUT_ID_Cita INT OUTPUT,
    @OUT_Mensaje NVARCHAR(255) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el paciente exista
    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente) BEGIN
        SET @OUT_Mensaje = 'Error: El paciente con ID ' + CAST(@ID_Paciente AS NVARCHAR) + ' no existe.';
        SET @OUT_ID_Cita = NULL;
        RETURN -1;
    END

    -- Validar que el médico exista
    IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico_Seleccionado) BEGIN
        SET @OUT_Mensaje = 'Error: El médico con ID ' + CAST(@ID_Medico_Seleccionado AS NVARCHAR) + ' no existe.';
        SET @OUT_ID_Cita = NULL;
        RETURN -2;
    END

    -- Validar que la fecha y hora sean futuras
    IF @Fecha_Hora_Cita <= GETDATE() BEGIN
        SET @OUT_Mensaje = 'Error: La fecha y hora de la cita (' + CONVERT(NVARCHAR, @Fecha_Hora_Cita, 120) + ') debe ser en el futuro.';
        SET @OUT_ID_Cita = NULL;
        RETURN -3;
    END

    -- Validar que el médico no tenga otra cita en la misma fecha y hora
    IF EXISTS (SELECT 1 FROM Cita
               WHERE ID_Medico = @ID_Medico_Seleccionado
                 AND Fecha_Hora = @Fecha_Hora_Cita
                 AND Estado_Cita IN ('Programada', 'Confirmada'))
    BEGIN
       SET @OUT_Mensaje = 'Error: El médico seleccionado ya tiene una cita programada para ' + CONVERT(NVARCHAR, @Fecha_Hora_Cita, 120) + '.';
       SET @OUT_ID_Cita = NULL;
       RETURN -4;
    END

    BEGIN TRY
        -- Insertar la cita
        INSERT INTO Cita (Fecha_Hora, ID_Paciente, ID_Medico, Estado_Cita)
        VALUES (@Fecha_Hora_Cita, @ID_Paciente, @ID_Medico_Seleccionado, 'Programada');

        SET @OUT_ID_Cita = SCOPE_IDENTITY();
        SET @OUT_Mensaje = 'Cita programada exitosamente para el paciente ID ' + CAST(@ID_Paciente AS NVARCHAR) + ' con el Médico ID: ' + CAST(@ID_Medico_Seleccionado AS NVARCHAR) + '. ID Cita: ' + CAST(@OUT_ID_Cita AS NVARCHAR);
        RETURN 0; -- Éxito
    END TRY
    BEGIN CATCH
        SET @OUT_Mensaje = 'Error SQL al insertar la cita: ' + ERROR_MESSAGE();
        SET @OUT_ID_Cita = NULL;
        RETURN -99;
    END CATCH
END;
GO
PRINT 'Procedimiento ProgramarCitaManual creado.';