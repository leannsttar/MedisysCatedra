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


