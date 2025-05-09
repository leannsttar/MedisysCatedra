-- ==========================================================================
-- Script Base de Datos Medisy
--           Creación de procedimientos almacenados CRUD
--           almacenados (Versión Simplificada)
-- ==========================================================================


-- ==========================================================================
-- 5. Procedimientos Almacenados CRUD
-- ==========================================================================

PRINT 'Creando Procedimientos Almacenados CRUD...';
GO

-- CRUD: CREATE (Insertar Paciente)
PRINT 'Creando procedimiento InsertarPaciente...';
GO
CREATE PROCEDURE InsertarPaciente (
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Direccion NVARCHAR(200) = NULL,
    @Fecha_Nacimiento DATE = NULL,
    @Sexo NVARCHAR(10) = NULL,
    @Telefono NVARCHAR(20) = NULL,
    @Contacto_Emergencia NVARCHAR(100) = NULL,
    @Telefono_Contacto_Emergencia NVARCHAR(20) = NULL
)
AS
BEGIN
    -- Documentación interna: Inserta un nuevo registro en la tabla Paciente. Realiza validaciones básicas.
    SET NOCOUNT ON;
    IF LTRIM(RTRIM(ISNULL(@Nombre, ''))) = '' OR LTRIM(RTRIM(ISNULL(@Apellido, ''))) = '' BEGIN
        PRINT 'Error: El nombre y el apellido del paciente son obligatorios.';
        RAISERROR('El nombre y el apellido del paciente son obligatorios.', 16, 1);
        RETURN -1;
    END
    IF @Sexo IS NOT NULL AND @Sexo NOT IN ('Masculino', 'Femenino') BEGIN
        PRINT 'Error: El valor para Sexo no es válido. Use "Masculino" o "Femenino".';
        RAISERROR('El valor para Sexo no es válido. Use "Masculino" o "Femenino".', 16, 1);
        RETURN -2;
    END
    BEGIN TRY
        INSERT INTO Paciente (Nombre, Apellido, Direccion, Fecha_Nacimiento, Sexo, Telefono, Contacto_Emergencia, Telefono_Contacto_Emergencia)
        VALUES (@Nombre, @Apellido, @Direccion, @Fecha_Nacimiento, @Sexo, @Telefono, @Contacto_Emergencia, @Telefono_Contacto_Emergencia);
        PRINT 'Paciente insertado correctamente. ID: ' + CAST(SCOPE_IDENTITY() AS NVARCHAR);
        RETURN SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        PRINT 'Error SQL al insertar paciente: ' + ERROR_MESSAGE();
        RAISERROR('Error al insertar paciente.', 16, 1);
        RETURN -99;
    END CATCH
END;
GO
PRINT 'Procedimiento InsertarPaciente creado.';

-- CRUD: UPDATE (Actualizar Información de Paciente)
PRINT 'Creando procedimiento ActualizarPaciente...';
GO
CREATE PROCEDURE ActualizarPaciente (
    @ID_Paciente INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Direccion NVARCHAR(200) = NULL,
    @Fecha_Nacimiento DATE = NULL,
    @Sexo NVARCHAR(10) = NULL,
    @Telefono NVARCHAR(20) = NULL,
    @Contacto_Emergencia NVARCHAR(100) = NULL,
    @Telefono_Contacto_Emergencia NVARCHAR(20) = NULL
)
AS
BEGIN
    -- Documentación interna: Actualiza un registro existente en la tabla Paciente. Realiza validaciones básicas.
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        PRINT 'Error: El paciente con ID ' + CAST(@ID_Paciente AS NVARCHAR) + ' no existe.';
        RAISERROR('El paciente especificado no existe.', 16, 1);
        RETURN -1; -- Error: Paciente no existe
    END

    IF LTRIM(RTRIM(ISNULL(@Nombre, ''))) = '' OR LTRIM(RTRIM(ISNULL(@Apellido, ''))) = '' BEGIN
        PRINT 'Error: El nombre y el apellido del paciente son obligatorios.';
        RAISERROR('El nombre y el apellido del paciente son obligatorios.', 16, 1);
        RETURN -2; -- Error: Campos obligatorios vacíos
    END

    IF @Sexo IS NOT NULL AND @Sexo NOT IN ('Masculino', 'Femenino') BEGIN
        PRINT 'Error: El valor para Sexo no es válido. Use "Masculino" o "Femenino".';
        RAISERROR('El valor para Sexo no es válido. Use "Masculino" o "Femenino".', 16, 1);
        RETURN -3; -- Error: Valor de sexo inválido
    END

    BEGIN TRY
        UPDATE Paciente SET
            Nombre = @Nombre,
            Apellido = @Apellido,
            Direccion = @Direccion,
            Fecha_Nacimiento = @Fecha_Nacimiento,
            Sexo = @Sexo,
            Telefono = @Telefono,
            Contacto_Emergencia = @Contacto_Emergencia,
            Telefono_Contacto_Emergencia = @Telefono_Contacto_Emergencia
        WHERE ID_Paciente = @ID_Paciente;

        IF @@ROWCOUNT = 0
        BEGIN
            -- Esto no debería pasar si la validación de existencia previa fue exitosa,
            -- pero es una salvaguarda.
            PRINT 'Advertencia: No se actualizó ninguna fila para el paciente ID ' + CAST(@ID_Paciente AS NVARCHAR) + '. Verifique los datos o la concurrencia.';
            RETURN 0; -- Técnicamente no es un error de SP, pero no se hizo nada.
        END

        PRINT 'Paciente ID ' + CAST(@ID_Paciente AS NVARCHAR) + ' actualizado correctamente.';
        RETURN 0; -- Éxito
    END TRY
    BEGIN CATCH
        PRINT 'Error SQL al actualizar paciente: ' + ERROR_MESSAGE();
        RAISERROR('Error al actualizar paciente.', 16, 1);
        RETURN -99; -- Error SQL genérico
    END CATCH
END;
GO
PRINT 'Procedimiento ActualizarPaciente creado.';
PRINT 'Procedimientos Almacenados CRUD actualizados.';
GO

-- CRUD: READ (Obtener Visitas de un Paciente)
PRINT 'Creando procedimiento ObtenerVisitasPaciente...';
GO
CREATE PROCEDURE ObtenerVisitasPaciente (
    @ID_Paciente INT
)
AS
BEGIN
    -- Documentación interna: Obtiene el historial de visitas médicas para un paciente específico.
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente) BEGIN
        PRINT 'Error: El paciente con ID ' + CAST(@ID_Paciente AS NVARCHAR) + ' no existe.';
        RAISERROR('El paciente especificado no existe.', 16, 1);
        RETURN -1;
    END
    SELECT v.ID_Visita, v.Fecha_Visita, p.Nombre AS NombreMedico, p.Apellido AS ApellidoMedico, e.Nombre_Especialidad, v.Motivo_Consulta, v.Diagnostico
    FROM Visita_Medica v
    INNER JOIN Medico m ON v.ID_Medico = m.ID_Medico
    INNER JOIN Personal p ON m.ID_Medico = p.ID_Personal
    INNER JOIN Especialidad e ON m.ID_Especialidad = e.ID_Especialidad
    WHERE v.ID_Paciente = @ID_Paciente
    ORDER BY v.Fecha_Visita DESC;
    RETURN 0; -- Éxito
END;
GO
PRINT 'Procedimiento ObtenerVisitasPaciente creado.';

-- CRUD: UPDATE (Actualizar Estado de una Cita)
PRINT 'Creando procedimiento ActualizarEstadoCita...';
GO
CREATE PROCEDURE ActualizarEstadoCita (
    @ID_Cita INT,
    @Nuevo_Estado NVARCHAR(50)
)
AS
BEGIN
    -- Documentación interna: Modifica el estado de una cita específica.
    SET NOCOUNT ON;
    DECLARE @EstadoValido BIT = 0;

    SELECT @EstadoValido = 1
    FROM   INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE usage
    JOIN   INFORMATION_SCHEMA.CHECK_CONSTRAINTS checks ON usage.CONSTRAINT_NAME = checks.CONSTRAINT_NAME
    WHERE  usage.TABLE_NAME = 'Cita' AND usage.COLUMN_NAME = 'Estado_Cita' AND checks.CHECK_CLAUSE LIKE '%' + @Nuevo_Estado + '%';

    IF @EstadoValido = 0 BEGIN
        PRINT 'Error: El estado "' + ISNULL(@Nuevo_Estado,'NULL') + '" no es válido para una cita.';
        RAISERROR('El estado proporcionado no es válido.', 16, 1);
        RETURN -2;
    END

    BEGIN TRY
        UPDATE Cita SET Estado_Cita = @Nuevo_Estado WHERE ID_Cita = @ID_Cita;
        IF @@ROWCOUNT = 0 BEGIN
            PRINT 'Error: La cita con ID ' + CAST(@ID_Cita AS NVARCHAR) + ' no existe o no se pudo actualizar.';
            RAISERROR('La cita especificada no existe.', 16, 1);
            RETURN -1;
        END
        PRINT 'Estado de la cita ' + CAST(@ID_Cita AS NVARCHAR) + ' actualizado a "' + @Nuevo_Estado + '".';
        RETURN 0; -- Éxito
    END TRY
    BEGIN CATCH
        PRINT 'Error SQL al actualizar la cita: ' + ERROR_MESSAGE();
        RAISERROR('Error al actualizar la cita.', 16, 1);
        RETURN -99;
    END CATCH
END;
GO
PRINT 'Procedimiento ActualizarEstadoCita creado.';
PRINT 'Procedimientos Almacenados CRUD creados.';