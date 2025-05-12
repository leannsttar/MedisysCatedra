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


/* ==========================================================================
Triggers de Auditoría 
Propósito: Registrar automáticamente en la tabla BITACORA todas las operaciones INSERT, UPDATE y DELETE realizadas sobre la tabla Cita.
==========================================================================

Cada trigger inserta un registro en la tabla BITACORA con la siguiente información:
- Usuario_sistema: Usuario de SQL Server que realizó la operación.
- Nombre_tabla: Siempre 'Cita' para identificar la tabla afectada.
- Transaccion: Tipo de operación realizada ('INSERT', 'UPDATE', 'DELETE').
- Detalle_PK: Clave primaria afectada (ID_Cita).

Esto permite llevar un historial de auditoría de todas las modificaciones sobre la tabla Cita.

Ejemplo de registro en BITACORA tras un INSERT:
| Usuario_sistema | Nombre_tabla | Transaccion | Detalle_PK      |
|-----------------|--------------|-------------|-----------------|
| admin           | Cita         | INSERT      | ID_Cita: 15     |

========================================================================== */
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
/* ======================================================================
Nombre: InsertarPaciente
Propósito: Inserta un nuevo paciente en la base de datos con validación exhaustiva de datos.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Permite registrar un nuevo paciente en el sistema, validando que **todos los campos sean obligatorios** (nombre, apellido, dirección, fecha de nacimiento, sexo, teléfono, contacto de emergencia y teléfono de contacto de emergencia), que el sexo sea válido y que los datos cumplan con las restricciones de formato y longitud.

Parámetros:
@Nombre                        - (Requerido) Nombre del paciente (máx 100 caracteres)
@Apellido                      - (Requerido) Apellido del paciente (máx 100 caracteres)
@Direccion                     - (Requerido) Dirección de residencia (máx 200 caracteres)
@Fecha_Nacimiento              - (Requerido) Fecha de nacimiento (formato YYYY-MM-DD)
@Sexo                          - (Requerido) Sexo del paciente ('Masculino' o 'Femenino')
@Telefono                      - (Requerido) Teléfono del paciente (máx 20 caracteres)
@Contacto_Emergencia           - (Requerido) Nombre del contacto de emergencia (máx 100 caracteres)
@Telefono_Contacto_Emergencia  - (Requerido) Teléfono del contacto de emergencia (máx 20 caracteres)

Códigos de Retorno:
-1  - Algún campo obligatorio vacío
-2  - Sexo inválido
-3  - Longitud de campo excedida
-4  - Fecha de nacimiento inválida (futura)
-99 - Error de sistema
Otro valor: ID del paciente insertado (éxito)

Ejemplo de uso:
-- Caso exitoso (todos los parámetros)
DECLARE @ID INT;
EXEC @ID = InsertarPaciente 
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Nombre vacío
EXEC InsertarPaciente 
    @Nombre = N'',
    @Apellido = N'Perez',
    @Direccion = N'Avenida Sol #45, Santa Tecla',
    @Fecha_Nacimiento = '1992-11-30',
    @Sexo = N'Masculino',
    @Telefono = N'7171-2020',
    @Contacto_Emergencia = N'Maria Rodriguez',
    @Telefono_Contacto_Emergencia = N'7171-2021';

-- Caso: Sexo inválido
EXEC InsertarPaciente 
    @Nombre = N'Juan',
    @Apellido = N'Perez',
    @Direccion = N'Avenida Sol #45, Santa Tecla',
    @Fecha_Nacimiento = '1992-11-30',
    @Sexo = N'Otro',
    @Telefono = N'7171-2020',
    @Contacto_Emergencia = N'Maria Rodriguez',
    @Telefono_Contacto_Emergencia = N'7171-2021';


-- Caso: Fecha de nacimiento futura
EXEC InsertarPaciente 
    @Nombre = N'Juan',
    @Apellido = N'Perez',
    @Direccion = N'Avenida Sol #45, Santa Tecla',
    @Fecha_Nacimiento = '2099-01-01',
    @Sexo = N'Masculino',
    @Telefono = N'7171-2020',
    @Contacto_Emergencia = N'Maria Rodriguez',
    @Telefono_Contacto_Emergencia = N'7171-2021';

Notas:
- Todos los campos son obligatorios y deben cumplir con las restricciones de longitud y formato.
- El procedimiento retorna el ID del paciente insertado si la operación es exitosa.
- Si ocurre un error, retorna un código negativo según el tipo de error.
======================================================================= */
CREATE PROCEDURE InsertarPaciente (
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Direccion NVARCHAR(200),
    @Fecha_Nacimiento DATE,
    @Sexo NVARCHAR(10),
    @Telefono NVARCHAR(20),
    @Contacto_Emergencia NVARCHAR(100),
    @Telefono_Contacto_Emergencia NVARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que todos los campos sean obligatorios y no vacíos
    IF LTRIM(RTRIM(ISNULL(@Nombre, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Apellido, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Direccion, ''))) = '' OR
       @Fecha_Nacimiento IS NULL OR
       LTRIM(RTRIM(ISNULL(@Sexo, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Telefono, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Contacto_Emergencia, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Telefono_Contacto_Emergencia, ''))) = ''
    BEGIN
        RAISERROR('Error -1: Todos los campos son obligatorios y no pueden estar vacíos.', 16, 1);
        RETURN -1;
    END

    -- Validar sexo
    IF @Sexo NOT IN ('Masculino', 'Femenino')
    BEGIN
        RAISERROR('Error -2: El valor para Sexo no es válido. Use "Masculino" o "Femenino".', 16, 1);
        RETURN -2;
    END


    -- Validar que la fecha de nacimiento no sea futura
    IF @Fecha_Nacimiento > GETDATE()
    BEGIN
        RAISERROR('Error -4: La fecha de nacimiento no puede ser futura.', 16, 1);
        RETURN -4;
    END

    BEGIN TRY
        INSERT INTO Paciente (Nombre, Apellido, Direccion, Fecha_Nacimiento, Sexo, Telefono, Contacto_Emergencia, Telefono_Contacto_Emergencia)
        VALUES (@Nombre, @Apellido, @Direccion, @Fecha_Nacimiento, @Sexo, @Telefono, @Contacto_Emergencia, @Telefono_Contacto_Emergencia);
        RETURN SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        DECLARE @MensajeError NVARCHAR(4000);
        SET @MensajeError = 'Error -99: Error al insertar paciente - ' + ERROR_MESSAGE();
        RAISERROR(@MensajeError, 16, 1);
        RETURN -99;
    END CATCH
END;
GO
PRINT 'Procedimiento InsertarPaciente creado.';


PRINT 'Creando procedimiento ActualizarPaciente...';
GO

/* ======================================================================
Nombre: ActualizarPaciente
Propósito: Actualiza los datos de un paciente existente en la base de datos, validando exhaustivamente los datos de entrada.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Permite modificar los datos de un paciente ya registrado, validando que el paciente exista y que **todos los campos sean obligatorios** (nombre, apellido, dirección, fecha de nacimiento, sexo, teléfono, contacto de emergencia y teléfono de contacto de emergencia). Además, valida que el sexo sea válido y que los datos cumplan con las restricciones de formato y longitud.

Parámetros:
@ID_Paciente                   - (Requerido) Identificador único del paciente (entero positivo)
@Nombre                        - (Requerido) Nombre del paciente (máx 100 caracteres)
@Apellido                      - (Requerido) Apellido del paciente (máx 100 caracteres)
@Direccion                     - (Requerido) Dirección de residencia (máx 200 caracteres)
@Fecha_Nacimiento              - (Requerido) Fecha de nacimiento (formato YYYY-MM-DD)
@Sexo                          - (Requerido) Sexo del paciente ('Masculino' o 'Femenino')
@Telefono                      - (Requerido) Teléfono del paciente (máx 20 caracteres)
@Contacto_Emergencia           - (Requerido) Nombre del contacto de emergencia (máx 100 caracteres)
@Telefono_Contacto_Emergencia  - (Requerido) Teléfono del contacto de emergencia (máx 20 caracteres)

Códigos de Retorno:
-1  - Paciente no existe
-2  - Algún campo obligatorio vacío
-3  - Sexo inválido
-4  - Longitud de campo excedida
-5  - Fecha de nacimiento inválida (futura)
-99 - Error de sistema
0   - Actualización exitosa

Ejemplo de uso:
-- Caso exitoso (todos los parámetros válidos)
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Paciente no existe
EXEC ActualizarPaciente 
    @ID_Paciente = 9999,
    @Nombre = N'Juan',
    @Apellido = N'Perez',
    @Direccion = N'Avenida Sol #45, Santa Tecla',
    @Fecha_Nacimiento = '1992-11-30',
    @Sexo = N'Masculino',
    @Telefono = N'7171-2020',
    @Contacto_Emergencia = N'Maria Rodriguez',
    @Telefono_Contacto_Emergencia = N'7171-2021';

-- Caso: Nombre vacío
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Dirección vacía
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Fecha de nacimiento vacía
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = NULL,
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Sexo inválido
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Otro',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';


-- Caso: Fecha de nacimiento futura
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '2099-01-01',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

Notas:
- Todos los campos son obligatorios y deben cumplir con las restricciones de longitud y formato.
- El procedimiento retorna 0 si la actualización es exitosa.
- Si ocurre un error, retorna un código negativo según el tipo de error y muestra un mensaje específico.
======================================================================= */

CREATE PROCEDURE ActualizarPaciente (
    @ID_Paciente INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Direccion NVARCHAR(200),
    @Fecha_Nacimiento DATE,
    @Sexo NVARCHAR(10),
    @Telefono NVARCHAR(20),
    @Contacto_Emergencia NVARCHAR(100),
    @Telefono_Contacto_Emergencia NVARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar existencia del paciente
    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('Error -1: El paciente especificado no existe.', 16, 1);
        RETURN -1;
    END

    -- Validar que todos los campos sean obligatorios y no vacíos
    IF LTRIM(RTRIM(ISNULL(@Nombre, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Apellido, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Direccion, ''))) = '' OR
       @Fecha_Nacimiento IS NULL OR
       LTRIM(RTRIM(ISNULL(@Sexo, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Telefono, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Contacto_Emergencia, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Telefono_Contacto_Emergencia, ''))) = ''
    BEGIN
        RAISERROR('Error -2: Todos los campos son obligatorios y no pueden estar vacíos.', 16, 1);
        RETURN -2;
    END

    -- Validar sexo
    IF @Sexo NOT IN ('Masculino', 'Femenino')
    BEGIN
        RAISERROR('Error -3: El valor para Sexo no es válido. Use "Masculino" o "Femenino".', 16, 1);
        RETURN -3;
    END


    -- Validar que la fecha de nacimiento no sea futura
    IF @Fecha_Nacimiento > GETDATE()
    BEGIN
        RAISERROR('Error -5: La fecha de nacimiento no puede ser futura.', 16, 1);
        RETURN -5;
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
        DECLARE @MensajeError NVARCHAR(4000);
        SET @MensajeError = 'Error -99: Error al actualizar paciente - ' + ERROR_MESSAGE();
        RAISERROR(@MensajeError, 16, 1);
        RETURN -99;
    END CATCH
END;
GO

PRINT 'Procedimiento ActualizarPaciente creado.';
PRINT 'Procedimientos Almacenados CRUD actualizados.';
GO


-- CRUD: READ (Obtener Visitas de un Paciente)
/* ======================================================================
Nombre: ObtenerVisitasPaciente
Propósito: Devuelve la lista de visitas médicas asociadas a un paciente específico.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Obtiene todas las visitas médicas registradas para un paciente, mostrando información relevante del médico y especialidad.

Parámetros:
@ID_Paciente - (Requerido) Identificador único del paciente (entero positivo)

Códigos de Retorno:
 0  - Consulta exitosa
-1  - Paciente no existe
-99 - Error de sistema

Ejemplo de uso:
-- Caso exitoso
EXEC ObtenerVisitasPaciente @ID_Paciente = 1;

-- Caso: Paciente no existe
EXEC ObtenerVisitasPaciente @ID_Paciente = 9999;

Notas:
- El parámetro ID_Paciente es obligatorio y debe existir en la tabla Paciente.
- Si el paciente no existe, retorna -1 y muestra un mensaje de error.
- Si ocurre un error de sistema, retorna -99.
======================================================================= */
-- CRUD: READ (Obtener Visitas de un Paciente)
PRINT 'Creando procedimiento ObtenerVisitasPaciente...';
GO
CREATE PROCEDURE ObtenerVisitasPaciente (
    @ID_Paciente INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('El paciente especificado no existe.', 16, 1);
        RETURN -1;
    END

    BEGIN TRY
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
    END TRY
    BEGIN CATCH
        DECLARE @MensajeError NVARCHAR(4000);
        SET @MensajeError = 'Error 99: Error al obtener visitas del paciente - ' + ERROR_MESSAGE();
        RAISERROR(@MensajeError, 16, 1);
        RETURN -99;
    END CATCH
END;
GO
PRINT 'Procedimiento ObtenerVisitasPaciente creado.';

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

-- Lógica de Negocio 2 (NUEVO): Registrar Visita Médica y Completar Cita
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


/* ======================================================================
Nombre: CancelarCitasAntiguas
Propósito: Cancela automáticamente todas las citas pasadas que no han sido realizadas ni canceladas.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Este procedimiento recorre todas las citas cuya fecha/hora ya pasó y que aún no tienen estado 'Realizada' ni 'Cancelada', y las marca como 'Cancelada'.

Parámetros:
(No recibe parámetros)


-- Asegúrate de tener un paciente y un médico válidos
DECLARE @PacienteID INT = 1; -- Reemplaza con un ID real
DECLARE @MedicoID INT = 1;   -- Reemplaza con un ID real

-- Insertar cita en el pasado
INSERT INTO Cita (Fecha_Hora, ID_Paciente, ID_Medico, Estado_Cita)
VALUES (DATEADD(DAY, -5, GETDATE()), @PacienteID, @MedicoID, 'Programada');

select * from Cita

EXEC CancelarCitasAntiguas;

Notas:
- Solo afecta citas con Fecha_Hora menor a la fecha/hora actual y cuyo Estado_Cita no sea 'Realizada' ni 'Cancelada'.
- El procedimiento utiliza un cursor simple para recorrer y actualizar cada cita antigua.
- No retorna ningún valor explícito.
======================================================================= */
GO
CREATE PROCEDURE CancelarCitasAntiguas
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ID_Cita INT;

    -- Cursor simple para recorrer las citas antiguas no realizadas ni canceladas
    DECLARE citas_cursor CURSOR FOR
        SELECT ID_Cita
        FROM Cita
        WHERE Fecha_Hora < GETDATE()
          AND Estado_Cita NOT IN ('Realizada', 'Cancelada');

    OPEN citas_cursor;
    FETCH NEXT FROM citas_cursor INTO @ID_Cita;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Actualiza el estado de la cita a 'Cancelada'
        UPDATE Cita
        SET Estado_Cita = 'Cancelada'
        WHERE ID_Cita = @ID_Cita;

        -- Siguiente cita
        FETCH NEXT FROM citas_cursor INTO @ID_Cita;
    END

    CLOSE citas_cursor;
    DEALLOCATE citas_cursor;
END;

PRINT 'Procedimientos Almacenados con Lógica de Negocio actualizados.';
GO





-- ==========================================================================
-- Script de Inserción de Datos de Ejemplo para Medisys
-- ==========================================================================

-- Usar la base de datos
-- USE medisys;
-- GO

-- ===================================
-- 1. Insertar Roles
-- ===================================
PRINT 'Insertando datos en Rol...';
INSERT INTO Rol (Nombre_Rol) VALUES
('Administrador'),
('Médico'),
('Recepcionista');
GO
PRINT 'Datos de Rol insertados.';

-- ===================================
-- 2. Insertar Especialidades
-- ===================================
PRINT 'Insertando datos en Especialidad...';
INSERT INTO Especialidad (Nombre_Especialidad) VALUES
('Cardiología'),
('Pediatría'),
('Medicina General'),
('Dermatología'),
('Ginecología y Obstetricia'),
('Traumatología');
GO
PRINT 'Datos de Especialidad insertados.';

-- ===================================
-- 3. Insertar Personal
-- ===================================
PRINT 'Insertando datos en Personal...';
INSERT INTO Personal (Nombre, Apellido, Telefono, Email, ID_Rol) VALUES
('Carlos', 'Rivera', '7777-1111', 'carlos.rivera@medisys.com', 2),
('Ana', 'Gomez', '7777-2222', 'ana.gomez@medisys.com', 2),
('Lucia', 'Fernandez', '7777-3333', 'lucia.fernandez@medisys.com', 3),
('Sofia', 'Lopez', '7777-5555', 'sofia.lopez@medisys.com', 1),
('Jorge', 'Salazar', '7777-6666', 'jorge.salazar@medisys.com', 2);
GO
PRINT 'Datos de Personal insertados.';

-- ===================================
-- 4. Insertar Médicos
-- ===================================
PRINT 'Insertando datos en Medico...';
INSERT INTO Medico (ID_Medico, Cedula_Profesional, ID_Especialidad) VALUES
(1, 'CP100200', 1),
(2, 'CP300400', 3),
(5, 'CP500600', 2); -- Jorge Salazar (ID_Personal = 5)
GO
PRINT 'Datos de Medico insertados.';

-- ===================================
-- 5. Insertar Usuarios
-- ===================================
PRINT 'Insertando datos en Usuario...';
INSERT INTO Usuario (ID_Personal, Username, PasswordHash, Activo) VALUES
(1, 'crivera', 'password', 1), -- Nueva contraseña: 'CarlosNew1!'
(2, 'agomez', 'password', 1), -- Nueva contraseña: ''
(3, 'lfernandez', 'password', 1), -- Nueva contraseña: ''
(4, 'slopez', 'password', 1);  -- Nueva contraseña: ''

GO
PRINT 'Datos de Usuario insertados.';

-- ===================================
-- 6. Insertar Pacientes
-- ===================================
PRINT 'Insertando datos en Paciente...';
INSERT INTO Paciente (Nombre, Apellido, Direccion, Fecha_Nacimiento, Sexo, Telefono, Contacto_Emergencia, Telefono_Contacto_Emergencia) VALUES
('Elena', 'Morales', 'Calle Luna #123, San Salvador', '1985-05-15', 'Femenino', '7070-1010', 'Roberto Morales', '7070-1011'),
('Juan', 'Perez', 'Avenida Sol #45, Santa Tecla', '1992-11-30', 'Masculino', '7171-2020', 'Maria Rodriguez', '7171-2021'),
('Beatriz', 'Castro', 'Colonia Las Flores, Pje. 2, #7', '2018-07-22', 'Femenino', '7272-3030', 'Carlos Castro', '7272-3031'),
('Mario', 'Hernandez', 'Residencial Los Santos, Pol. B, #10', '1970-01-10', 'Masculino', '7373-4040', 'Luisa de Hernandez', '7373-4041');
GO
PRINT 'Datos de Paciente insertados.';

-- ===================================
-- 7. Insertar Citas
-- ===================================
PRINT 'Insertando datos en Cita...';
INSERT INTO Cita (Fecha_Hora, ID_Paciente, ID_Medico, Estado_Cita) VALUES
(DATEADD(day, 7, GETDATE()), 1, 1, 'Programada'),
(DATEADD(day, 3, GETDATE()), 2, 2, 'Confirmada'),
(DATEADD(day, 10, GETDATE()), 3, 5, 'Programada'),
(DATEADD(day, -2, GETDATE()), 1, 2, 'Realizada'),
(DATEADD(day, -5, GETDATE()), 2, 1, 'Cancelada');
GO
PRINT 'Datos de Cita insertados.';

-- ===================================
-- 8. Insertar Visitas Médicas
-- ===================================
PRINT 'Insertando datos en Visita_Medica...';
INSERT INTO Visita_Medica (ID_Paciente, ID_Medico, ID_Cita, Fecha_Visita, Talla, Peso, Tension_Arterial, Pulso, Spo2, Temperatura, Motivo_Consulta, Examen_Fisico, Diagnostico, Plan_Tratamiento) VALUES
(1, 2, 4, DATEADD(day, -2, GETDATE()), 1.60, 65.5, '120/80 mmHg', 75, 98, 36.8,
'Chequeo general anual.',
'Paciente afebril, consciente, orientada. Auscultación cardiopulmonar sin hallazgos patológicos. Abdomen blando, depresible, no doloroso.',
'Paciente sana, control de rutina.',
'Continuar estilo de vida saludable, próxima cita en 1 año o según necesidad.'),

(2, 2, NULL, DATEADD(day, -10, GETDATE()), 1.75, 80.2, '130/85 mmHg', 80, 97, 37.1,
'Tos persistente y malestar general desde hace 3 días.',
'Faringe congestiva, leve eritema. Campos pulmonares con murmullo vesicular conservado, sin estertores. Leve febrícula.',
'Faringitis viral.',
'Reposo, hidratación abundante, paracetamol 500mg cada 8 horas si hay fiebre o dolor. Reconsulta si no mejora en 3-5 días o aparecen síntomas de alarma.'),

(3, 5, NULL, DATEADD(day, -1, GETDATE()), 0.95, 14.0, '90/60 mmHg', 110, 99, 37.5,
'Control de niño sano y vacunas.',
'Niña activa, reactiva. Buen estado de hidratación y nutrición. Desarrollo psicomotor acorde a edad. Se administran vacunas correspondientes al esquema.',
'Niña sana, control pediátrico.',
'Próximo control según calendario de vacunación. Consejos sobre alimentación complementaria.');
GO
PRINT 'Datos de Visita_Medica insertados.';

-- ===================================
-- Fin del Script
-- ===================================
PRINT '=================================================='
PRINT 'Inserción de datos de ejemplo completada.'
PRINT '=================================================='
GO
