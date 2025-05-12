-- ==========================================================================
-- Script Base de Datos Medisys
--           Creación de tablas, relaciones, auditoría 
-- ==========================================================================

-- ===================================
-- 1. Crear y Usar la Base de Datos
-- ===================================
--DROP DATABASE IF EXISTS Medisys;
--GO
CREATE DATABASE medisys;
GO

--Diagram: https://kroki.io/mermaid/svg/eNqtVUtu2zAQ3ecUhDZJgLiLLrtTZRk2HLuqI2crTKSJTUAiDVJKg8Y5VY_Qi3Wojy2ZVIEU1UqYD9-bN8MhqimHnYLiitG3kTk7HicT-cYiVFoKyNkX5pUcBTLQfCcgk14devK_y8nkeGQrzHgqTTRqVgl2g_qAKYec_4SU__4lbt15W12B4nXiocIMWUlYik5owsPulAyyjtoZ6oDKhKdEzrtqjicwFCV2sQEv4VzCQUlTK2TQnN6edBELJpiYoBg59JFrCk3q7DpD4Y7rUgF7qT3sAMqJ4EisBery2qSayJH0kUc7pVFpZ1QC1RI0fXur_8y3WMdsMU2MMVqerOtHfxPM_Q1by-JJYe32tuvF923YoL5fDRtkHXjyjJ9q2_0D5tQ9aXtizPFZCocnLIBfkLuoa7bsUx4MiUV74P2LIIM4lzJtLy2A1h4tmTdbMjgp-KmnmWfDBphVOSSRks-oeS3sWMkDasPaT7Npt6vz_J92TbnCNCWeJ9fUj0M2w3QPyZqwCoPmSHzAV8m8YB4GS3ZzvQKdVjkX8vqOXc-wQGH-b72PzEcgRQlpKZOwQEU3gaQZT0_GolsB68tmiVdbe8KZWuPFqqt3LhWM6j1bjkzIzNGIUJe0Uxu8ViSsTXowe8M1YNFt3H3C_0KqXztNsreu8hyecvTGZGhgz94wWKz8exYD5VnWCLVzCwgz_IlPm1zRiA_IRFXeyzGWh4P8bONhQS8BlJVyzMFKlvylngJd5aUjIHwFmsJkRrWkzrmHnZC6dDqjHEQSEzT0pr9tWfeyWc3qHI5udRvWqN_sgjv2kZ2y1agElWNvkjNl0PqHVNkc9H6srwG9S4Or_nURMz81QvYrJKsffNv4lyVmCT2IzrXTlp5oei6xgDH8PV0vK-ZyX5c0mq57r0BoqDfVeess1g_hJjYrZxsZLPM3De9D-nOtnimWNMKYtCW8_wE4xoPy

USE medisys; 
GO

-- ===================================
-- 2. Creación de Tablas Principales
-- ===================================
PRINT 'Creando tablas principales...';

-- Tabla para definir los roles del personal
PRINT 'Creando tabla Rol...';
CREATE TABLE Rol (
    ID_Rol INT PRIMARY KEY IDENTITY,
    Nombre_Rol NVARCHAR(50) NOT NULL UNIQUE -- Rol debe ser único
);
GO

-- Tabla para almacenar información del personal de la clínica
PRINT 'Creando tabla Personal...';
CREATE TABLE Personal (
    ID_Personal INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL, -- Nombre es obligatorio
    Apellido NVARCHAR(100) NOT NULL, -- Apellido es obligatorio
    Telefono NVARCHAR(20) NULL,
    Email NVARCHAR(100) NULL UNIQUE, -- Email debe ser único si se proporciona
    ID_Rol INT NOT NULL, -- Todo personal debe tener un rol
    -- Documentación interna: Relación con la tabla Rol
    FOREIGN KEY (ID_Rol) REFERENCES Rol(ID_Rol)
);
GO

-- Tabla para las especialidades médicas
PRINT 'Creando tabla Especialidad...';
CREATE TABLE Especialidad (
    ID_Especialidad INT PRIMARY KEY IDENTITY,
    Nombre_Especialidad NVARCHAR(100) NOT NULL UNIQUE -- Nombre de especialidad debe ser único
);
GO

-- Tabla específica para médicos, vinculada a Personal
PRINT 'Creando tabla Medico...';
CREATE TABLE Medico (
    ID_Medico INT PRIMARY KEY, -- Mismo ID que en Personal (Relación 1:1)
    Cedula_Profesional NVARCHAR(50) NULL UNIQUE, -- Cédula/Colegiado debe ser único si se proporciona
    ID_Especialidad INT NOT NULL, -- Todo médico debe tener una especialidad
    -- Documentación interna: Relación 1:1 con Personal y relación con Especialidad
    FOREIGN KEY (ID_Medico) REFERENCES Personal(ID_Personal) ON DELETE CASCADE, -- Si se elimina el Personal, se elimina el Medico
    FOREIGN KEY (ID_Especialidad) REFERENCES Especialidad(ID_Especialidad) -- ON DELETE RESTRICT por defecto
);
GO

-- Tabla para almacenar información de los pacientes
PRINT 'Creando tabla Paciente...';
CREATE TABLE Paciente (
    ID_Paciente INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL, -- Añadido Apellido para completar nombre
    Direccion NVARCHAR(200) NULL,
    Fecha_Nacimiento DATE NULL,
    Sexo NVARCHAR(10) NULL CHECK (Sexo IN ('Masculino', 'Femenino')), -- Restricción de valores
    Telefono NVARCHAR(20) NULL,
    Contacto_Emergencia NVARCHAR(100) NULL,
    Telefono_Contacto_Emergencia NVARCHAR(20) NULL
);
GO

-- Tabla para gestionar las citas médicas
PRINT 'Creando tabla Cita...';
CREATE TABLE Cita (
    ID_Cita INT PRIMARY KEY IDENTITY,
    Fecha_Hora DATETIME NOT NULL,
    ID_Paciente INT NOT NULL,
    ID_Medico INT NOT NULL,
    Estado_Cita NVARCHAR(50) NOT NULL DEFAULT 'Programada' CHECK (Estado_Cita IN ('Programada', 'Confirmada', 'Cancelada', 'Realizada', 'No Asistio')), -- Estados definidos
    -- Documentación interna: Relaciones con Paciente y Medico
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente) ON DELETE CASCADE, -- Si se elimina Paciente, eliminar Citas
    FOREIGN KEY (ID_Medico) REFERENCES Medico(ID_Medico) ON DELETE CASCADE -- Si se elimina Medico, eliminar Citas
);
GO

-- Tabla para registrar los detalles de cada visita médica
PRINT 'Creando tabla Visita_Medica...';
CREATE TABLE Visita_Medica (
    ID_Visita INT PRIMARY KEY IDENTITY,
    ID_Paciente INT NOT NULL,
    ID_Medico INT NOT NULL,
    ID_Cita INT NULL, -- Puede haber visitas sin cita previa (emergencias)
    Fecha_Visita DATETIME NOT NULL DEFAULT GETDATE(), -- Fecha por defecto al momento del registro
    -- Signos vitales y mediciones
    Talla DECIMAL(5,2) NULL CHECK (Talla > 0), -- Validación básica
    Peso DECIMAL(5,2) NULL CHECK (Peso > 0), -- Validación básica
    Tension_Arterial NVARCHAR(20) NULL,
    Pulso INT NULL CHECK (Pulso > 0),
    Spo2 INT NULL CHECK (Spo2 BETWEEN 0 AND 100), -- Rango válido
    Temperatura DECIMAL(4,2) NULL,
    -- Información clínica
    Motivo_Consulta NVARCHAR(MAX) NULL,
    Examen_Fisico NVARCHAR(MAX) NULL,
    Diagnostico NVARCHAR(MAX) NULL,
    Plan_Tratamiento NVARCHAR(MAX) NULL,
    -- Documentación interna: Relaciones con Paciente, Medico y Cita (opcional)
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
    FOREIGN KEY (ID_Medico) REFERENCES Medico(ID_Medico),
    FOREIGN KEY (ID_Cita) REFERENCES Cita(ID_Cita) ON DELETE SET NULL -- Si se borra la cita, la visita queda sin cita asociada
);
GO

-- NUEVA TABLA: Usuario
PRINT 'Creando tabla Usuario...';
CREATE TABLE Usuario (
    ID_Usuario INT PRIMARY KEY IDENTITY,
    ID_Personal INT NOT NULL UNIQUE, -- Un miembro del personal solo puede tener un usuario.
    Username NVARCHAR(50) NOT NULL UNIQUE, -- Nombre de usuario debe ser único
    PasswordHash NVARCHAR(255) NOT NULL, -- Almacenar HASH de la contraseña, no la contraseña en texto plano
    Fecha_Creacion DATETIME NOT NULL DEFAULT GETDATE(),
    Activo BIT NOT NULL DEFAULT 1, -- Para habilitar/deshabilitar usuarios
    -- Documentación interna: Relación con la tabla Personal
    FOREIGN KEY (ID_Personal) REFERENCES Personal(ID_Personal) ON DELETE CASCADE -- Si se elimina el Personal, se elimina su Usuario
);
GO
PRINT 'Tabla Usuario creada.';

-- ==========================================================================
-- 3. Tabla de Auditoría (BITACORA)
-- ==========================================================================
PRINT 'Creando tabla BITACORA...';
CREATE TABLE BITACORA (
    Id_reg INT IDENTITY PRIMARY KEY,
    Usuario_sistema NVARCHAR(128) NOT NULL,
    Fecha_hora_sistema DATETIME NOT NULL DEFAULT GETDATE(),
    Nombre_tabla NVARCHAR(128) NOT NULL,
    Transaccion NVARCHAR(10) NOT NULL CHECK (Transaccion IN ('INSERT', 'UPDATE', 'DELETE')),
    Detalle_PK NVARCHAR(255) NULL
);
GO
PRINT 'Tabla BITACORA creada.';


-- ==========================================================================
-- Script Base de Datos Medisy
--           Creación de Triggers
-- ==========================================================================

-- ==========================================================================
-- 4. Triggers de Auditoría (Trazabilidad)
-- ==========================================================================
PRINT 'Creando Triggers de Auditoría...';
GO

-- Triggers para la tabla Rol
PRINT 'Creando trigger trg_Rol_Audit_Insert...';
GO
CREATE TRIGGER trg_Rol_Audit_Insert ON Rol AFTER INSERT AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Rol', 'INSERT', CONCAT('ID_Rol: ', i.ID_Rol) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Rol_Audit_Update...';
GO
CREATE TRIGGER trg_Rol_Audit_Update ON Rol AFTER UPDATE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Rol', 'UPDATE', CONCAT('ID_Rol: ', i.ID_Rol) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Rol_Audit_Delete...';
GO
CREATE TRIGGER trg_Rol_Audit_Delete ON Rol AFTER DELETE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Rol', 'DELETE', CONCAT('ID_Rol: ', d.ID_Rol) FROM deleted d; END;
GO
PRINT 'Triggers para Rol creados.';

-- Triggers para la tabla Especialidad
PRINT 'Creando trigger trg_Especialidad_Audit_Insert...';
GO
CREATE TRIGGER trg_Especialidad_Audit_Insert ON Especialidad AFTER INSERT AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Especialidad', 'INSERT', CONCAT('ID_Especialidad: ', i.ID_Especialidad) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Especialidad_Audit_Update...';
GO
CREATE TRIGGER trg_Especialidad_Audit_Update ON Especialidad AFTER UPDATE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Especialidad', 'UPDATE', CONCAT('ID_Especialidad: ', i.ID_Especialidad) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Especialidad_Audit_Delete...';
GO
CREATE TRIGGER trg_Especialidad_Audit_Delete ON Especialidad AFTER DELETE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Especialidad', 'DELETE', CONCAT('ID_Especialidad: ', d.ID_Especialidad) FROM deleted d; END;
GO
PRINT 'Triggers para Especialidad creados.';

-- Triggers para la tabla Paciente
PRINT 'Creando trigger trg_Paciente_Audit_Insert...';
GO
CREATE TRIGGER trg_Paciente_Audit_Insert ON Paciente AFTER INSERT AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Paciente', 'INSERT', CONCAT('ID_Paciente: ', i.ID_Paciente) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Paciente_Audit_Update...';
GO
CREATE TRIGGER trg_Paciente_Audit_Update ON Paciente AFTER UPDATE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Paciente', 'UPDATE', CONCAT('ID_Paciente: ', i.ID_Paciente) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Paciente_Audit_Delete...';
GO
CREATE TRIGGER trg_Paciente_Audit_Delete ON Paciente AFTER DELETE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Paciente', 'DELETE', CONCAT('ID_Paciente: ', d.ID_Paciente) FROM deleted d; END;
GO
PRINT 'Triggers para Paciente creados.';

-- Triggers para la tabla Personal
PRINT 'Creando trigger trg_Personal_Audit_Insert...';
GO
CREATE TRIGGER trg_Personal_Audit_Insert ON Personal AFTER INSERT AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Personal', 'INSERT', CONCAT('ID_Personal: ', i.ID_Personal) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Personal_Audit_Update...';
GO
CREATE TRIGGER trg_Personal_Audit_Update ON Personal AFTER UPDATE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Personal', 'UPDATE', CONCAT('ID_Personal: ', i.ID_Personal) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Personal_Audit_Delete...';
GO
CREATE TRIGGER trg_Personal_Audit_Delete ON Personal AFTER DELETE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Personal', 'DELETE', CONCAT('ID_Personal: ', d.ID_Personal) FROM deleted d; END;
GO
PRINT 'Triggers para Personal creados.';

-- Triggers para la tabla Medico
PRINT 'Creando trigger trg_Medico_Audit_Insert...';
GO
CREATE TRIGGER trg_Medico_Audit_Insert ON Medico AFTER INSERT AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Medico', 'INSERT', CONCAT('ID_Medico: ', i.ID_Medico) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Medico_Audit_Update...';
GO
CREATE TRIGGER trg_Medico_Audit_Update ON Medico AFTER UPDATE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Medico', 'UPDATE', CONCAT('ID_Medico: ', i.ID_Medico) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Medico_Audit_Delete...';
GO
CREATE TRIGGER trg_Medico_Audit_Delete ON Medico AFTER DELETE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Medico', 'DELETE', CONCAT('ID_Medico: ', d.ID_Medico) FROM deleted d; END;
GO
PRINT 'Triggers para Medico creados.';

-- Triggers para la tabla Cita
PRINT 'Creando trigger trg_Cita_Audit_Insert...';
GO
CREATE TRIGGER trg_Cita_Audit_Insert ON Cita AFTER INSERT AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Cita', 'INSERT', CONCAT('ID_Cita: ', i.ID_Cita) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Cita_Audit_Update...';
GO
CREATE TRIGGER trg_Cita_Audit_Update ON Cita AFTER UPDATE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Cita', 'UPDATE', CONCAT('ID_Cita: ', i.ID_Cita) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Cita_Audit_Delete...';
GO
CREATE TRIGGER trg_Cita_Audit_Delete ON Cita AFTER DELETE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Cita', 'DELETE', CONCAT('ID_Cita: ', d.ID_Cita) FROM deleted d; END;
GO
PRINT 'Triggers para Cita creados.';

-- Triggers para la tabla Visita_Medica
PRINT 'Creando trigger trg_Visita_Medica_Audit_Insert...';
GO
CREATE TRIGGER trg_Visita_Medica_Audit_Insert ON Visita_Medica AFTER INSERT AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Visita_Medica', 'INSERT', CONCAT('ID_Visita: ', i.ID_Visita) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Visita_Medica_Audit_Update...';
GO
CREATE TRIGGER trg_Visita_Medica_Audit_Update ON Visita_Medica AFTER UPDATE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Visita_Medica', 'UPDATE', CONCAT('ID_Visita: ', i.ID_Visita) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Visita_Medica_Audit_Delete...';
GO
CREATE TRIGGER trg_Visita_Medica_Audit_Delete ON Visita_Medica AFTER DELETE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Visita_Medica', 'DELETE', CONCAT('ID_Visita: ', d.ID_Visita) FROM deleted d; END;
GO
PRINT 'Triggers para Visita_Medica creados.';

-- Triggers para la tabla Usuario
PRINT 'Creando trigger trg_Usuario_Audit_Insert...';
GO
CREATE TRIGGER trg_Usuario_Audit_Insert ON Usuario AFTER INSERT AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Usuario', 'INSERT', CONCAT('ID_Usuario: ', i.ID_Usuario) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Usuario_Audit_Update...';
GO
CREATE TRIGGER trg_Usuario_Audit_Update ON Usuario AFTER UPDATE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Usuario', 'UPDATE', CONCAT('ID_Usuario: ', i.ID_Usuario) FROM inserted i; END;
GO
PRINT 'Creando trigger trg_Usuario_Audit_Delete...';
GO
CREATE TRIGGER trg_Usuario_Audit_Delete ON Usuario AFTER DELETE AS BEGIN IF @@ROWCOUNT = 0 RETURN; SET NOCOUNT ON; INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK) SELECT SYSTEM_USER, 'Usuario', 'DELETE', CONCAT('ID_Usuario: ', d.ID_Usuario) FROM deleted d; END;
GO
PRINT 'Triggers para Usuario creados.';

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
    SET NOCOUNT ON;
    IF LTRIM(RTRIM(ISNULL(@Nombre, ''))) = '' OR LTRIM(RTRIM(ISNULL(@Apellido, ''))) = '' BEGIN
        RAISERROR('El nombre y el apellido del paciente son obligatorios.', 16, 1);
        RETURN -1;
    END
    IF @Sexo IS NOT NULL AND @Sexo NOT IN ('Masculino', 'Femenino') BEGIN
        RAISERROR('El valor para Sexo no es válido. Use "Masculino" o "Femenino".', 16, 1);
        RETURN -2;
    END
    BEGIN TRY
        INSERT INTO Paciente (Nombre, Apellido, Direccion, Fecha_Nacimiento, Sexo, Telefono, Contacto_Emergencia, Telefono_Contacto_Emergencia)
        VALUES (@Nombre, @Apellido, @Direccion, @Fecha_Nacimiento, @Sexo, @Telefono, @Contacto_Emergencia, @Telefono_Contacto_Emergencia);
        RETURN SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
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
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('El paciente especificado no existe.', 16, 1);
        RETURN -1; -- Error: Paciente no existe
    END

    IF LTRIM(RTRIM(ISNULL(@Nombre, ''))) = '' OR LTRIM(RTRIM(ISNULL(@Apellido, ''))) = '' BEGIN
        RAISERROR('El nombre y el apellido del paciente son obligatorios.', 16, 1);
        RETURN -2; -- Error: Campos obligatorios vacíos
    END

    IF @Sexo IS NOT NULL AND @Sexo NOT IN ('Masculino', 'Femenino') BEGIN
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

        RETURN 0; -- Éxito
    END TRY
    BEGIN CATCH
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
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente) BEGIN
        RAISERROR('El paciente especificado no existe.', 16, 1);
        RETURN -1;
    END

    SELECT v.ID_Visita, 
           v.Fecha_Visita, 
           CONCAT(p.Nombre, ' ', p.Apellido) AS Medico, -- Combina el nombre y apellido del médico
           e.Nombre_Especialidad, 
           v.Motivo_Consulta, 
           v.Diagnostico
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
-- PRINT 'Creando procedimiento ActualizarEstadoCita...';
-- GO
-- CREATE PROCEDURE ActualizarEstadoCita (
--     @ID_Cita INT,
--     @Nuevo_Estado NVARCHAR(50)
-- )
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     DECLARE @EstadoValido BIT = 0;

--     SELECT @EstadoValido = 1
--     FROM   INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE usage
--     JOIN   INFORMATION_SCHEMA.CHECK_CONSTRAINTS checks ON usage.CONSTRAINT_NAME = checks.CONSTRAINT_NAME
--     WHERE  usage.TABLE_NAME = 'Cita' AND usage.COLUMN_NAME = 'Estado_Cita' AND checks.CHECK_CLAUSE LIKE '%' + @Nuevo_Estado + '%';

--     IF @EstadoValido = 0 BEGIN
--         RAISERROR('El estado proporcionado no es válido.', 16, 1);
--         RETURN -2;
--     END

--     BEGIN TRY
--         UPDATE Cita SET Estado_Cita = @Nuevo_Estado WHERE ID_Cita = @ID_Cita;

--         IF @@ROWCOUNT = 0 BEGIN
--             RAISERROR('La cita especificada no existe.', 16, 1);
--             RETURN -1;
--         END

--         RETURN 0; -- Éxito
--     END TRY
--     BEGIN CATCH
--         RAISERROR('Error al actualizar la cita.', 16, 1);
--         RETURN -99;
--     END CATCH
-- END;
-- GO
-- PRINT 'Procedimiento ActualizarEstadoCita creado.';
-- PRINT 'Procedimientos Almacenados CRUD creados.';


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