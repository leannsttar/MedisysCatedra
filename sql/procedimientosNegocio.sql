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
PRINT 'Creando procedimiento ProgramarCitaManual...';
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

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente) BEGIN
        SET @OUT_Mensaje = 'Error: El paciente con ID ' + CAST(@ID_Paciente AS NVARCHAR) + ' no existe.';
        SET @OUT_ID_Cita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -1;
    END

    IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico_Seleccionado) BEGIN
        SET @OUT_Mensaje = 'Error: El médico con ID ' + CAST(@ID_Medico_Seleccionado AS NVARCHAR) + ' no existe.';
        SET @OUT_ID_Cita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -2;
    END

    IF @Fecha_Hora_Cita <= GETDATE() BEGIN
        SET @OUT_Mensaje = 'Error: La fecha y hora de la cita (' + CONVERT(NVARCHAR, @Fecha_Hora_Cita, 120) + ') debe ser en el futuro.';
        SET @OUT_ID_Cita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -3;
    END

    IF EXISTS (SELECT 1 FROM Cita
               WHERE ID_Medico = @ID_Medico_Seleccionado
                 AND Fecha_Hora = @Fecha_Hora_Cita
                 AND Estado_Cita IN ('Programada', 'Confirmada'))
    BEGIN
       SET @OUT_Mensaje = 'Error: El médico seleccionado ya tiene una cita programada para ' + CONVERT(NVARCHAR, @Fecha_Hora_Cita, 120) + '.';
       SET @OUT_ID_Cita = NULL;
       RAISERROR(@OUT_Mensaje, 16, 1);
       RETURN -4;
    END

    BEGIN TRY
        INSERT INTO Cita (Fecha_Hora, ID_Paciente, ID_Medico, Estado_Cita)
        VALUES (@Fecha_Hora_Cita, @ID_Paciente, @ID_Medico_Seleccionado, 'Programada');

        SET @OUT_ID_Cita = SCOPE_IDENTITY();
        SET @OUT_Mensaje = 'Cita programada exitosamente para el paciente ID ' + CAST(@ID_Paciente AS NVARCHAR) + ' con el Médico ID: ' + CAST(@ID_Medico_Seleccionado AS NVARCHAR) + '. ID Cita: ' + CAST(@OUT_ID_Cita AS NVARCHAR);
        PRINT @OUT_Mensaje;
        RETURN 0; -- Éxito
    END TRY
    BEGIN CATCH
        SET @OUT_Mensaje = 'Error SQL al insertar la cita: ' + ERROR_MESSAGE();
        SET @OUT_ID_Cita = NULL;
        RAISERROR(@OUT_Mensaje, 16, 1);
        RETURN -99;
    END CATCH
END;
GO
PRINT 'Procedimiento ProgramarCitaManual creado.';

-- Lógica de Negocio 2: Verificar si un paciente requiere seguimiento para una condición
PRINT 'Creando procedimiento VerificarPacienteRequiereSeguimiento...';
GO
CREATE PROCEDURE VerificarPacienteRequiereSeguimiento (
    @ID_Paciente INT,
    @Diagnostico_Busqueda NVARCHAR(100),
    @Meses_Atras INT = 6,
    @Requiere_Seguimiento BIT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @Requiere_Seguimiento = 0;

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente) BEGIN
        PRINT 'Error: El paciente especificado no existe.';
        RAISERROR('El paciente especificado no existe.', 16, 1);
        RETURN -1;
    END

    IF EXISTS (
        SELECT 1 FROM Visita_Medica
        WHERE ID_Paciente = @ID_Paciente
          AND Fecha_Visita >= DATEADD(month, -@Meses_Atras, GETDATE())
          AND Diagnostico LIKE '%' + @Diagnostico_Busqueda + '%'
    )
    BEGIN
        SET @Requiere_Seguimiento = 1;
        PRINT 'Resultado: El paciente SI requiere seguimiento basado en visitas recientes.';
    END
    ELSE
    BEGIN
        SET @Requiere_Seguimiento = 0;
        PRINT 'Resultado: El paciente NO requiere seguimiento basado en visitas recientes para el diagnóstico buscado.';
    END

    RETURN 0; -- Éxito en la ejecución de la lógica
END;
GO
PRINT 'Procedimiento VerificarPacienteRequiereSeguimiento creado.';
PRINT 'Procedimientos Almacenados con Lógica de Negocio creados.';
GO
