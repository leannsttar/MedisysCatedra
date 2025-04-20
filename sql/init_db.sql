-- Tabla de Usuarios
CREATE TABLE Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario NVARCHAR(50) NOT NULL UNIQUE,
    contrasena NVARCHAR(255) NOT NULL,
    correo NVARCHAR(100) NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE()
);

-- Tabla de Pacientes
CREATE TABLE Paciente (
    id_paciente INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    direccion NVARCHAR(200),
    fecha_nacimiento DATE NOT NULL,
    edad AS DATEDIFF(YEAR, fecha_nacimiento, GETDATE()),
    sexo CHAR(1) CHECK (sexo IN ('M', 'F', 'O')),
    telefono NVARCHAR(20) NOT NULL,
    correo NVARCHAR(100),
    contacto_emergencia NVARCHAR(100),
    telefono_emergencia NVARCHAR(20),
    notas TEXT,
    fecha_registro DATETIME DEFAULT GETDATE()
);

-- Tabla de Consultas
CREATE TABLE Consulta (
    id_consulta INT IDENTITY(1,1) PRIMARY KEY,
    id_paciente INT NOT NULL,
    medico_responsable NVARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente) ON DELETE CASCADE
);

-- Tabla de Signos Vitales
CREATE TABLE SignosVitales (
    id_signos INT IDENTITY(1,1) PRIMARY KEY,
    id_consulta INT NOT NULL,
    peso DECIMAL(5,2),
    talla DECIMAL(5,2),
    temperatura DECIMAL(4,2),
    spo2 DECIMAL(5,2),
    pulso INT,
    tension_arterial NVARCHAR(10),
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta) ON DELETE CASCADE
);

-- Tabla de Historia Clínica
CREATE TABLE HistoriaClinica (
    id_historia INT IDENTITY(1,1) PRIMARY KEY,
    id_consulta INT NOT NULL,
    cx TEXT,
    examen_fisico TEXT,
    dx TEXT,
    planMedico TEXT,
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta) ON DELETE CASCADE
);

-- Insertar usuario administrador por defecto
INSERT INTO Usuario (nombre_usuario, contraseña, correo) 
VALUES ('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin@medisys.com');
-- Contraseña: password