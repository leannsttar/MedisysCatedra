-- ==========================================================================
-- Script Base de Datos Medisy
--           Creación de procedimientos almacenados con lógica de negocio
--           almacenados (Versión Simplificada)
-- ==========================================================================

-- ==========================================================================
-- 6. Procedimientos Almacenados con Lógica de Negocio
-- ==========================================================================

PRINT 'Creando Procedimientos Almacenados con Lógica de Negocio...';
GO

-- Lógica de Negocio 1: Programar Cita (Selección Manual de Médico)
PRINT 'Creando procedimiento ProgramarCita...';
GO
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

-- Lógica de Negocio 2 (NUEVO): Registrar Visita Médica y Completar Cita
PRINT 'Creando procedimiento RegistrarVisitaCompleta...';
GO
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
PRINT 'Procedimientos Almacenados con Lógica de Negocio actualizados.';
GO