-- ==========================================================================
-- Script de Inserción de Datos de Ejemplo para Medisys
-- ==========================================================================

-- Usar la base de datos
USE medisys;
GO

-- ===================================
-- 1. Insertar Roles
-- ===================================
PRINT 'Insertando datos en Rol...';
INSERT INTO Rol (Nombre_Rol) VALUES
('Administrador'),
('Médico'),
('Recepcionista'),;
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
-- Asumiendo que los ID_Rol son 1=Administrador, 2=Médico, 3=Enfermero/a, 4=Recepcionista
INSERT INTO Personal (Nombre, Apellido, Telefono, Email, ID_Rol) VALUES
('Carlos', 'Rivera', '7777-1111', 'carlos.rivera@medisys.com', 2), -- Médico
('Ana', 'Gomez', '7777-2222', 'ana.gomez@medisys.com', 2),         -- Médico
('Lucia', 'Fernandez', '7777-3333', 'lucia.fernandez@medisys.com', 3), -- Enfermero/a
('Pedro', 'Martinez', '7777-4444', 'pedro.martinez@medisys.com', 4), -- Recepcionista
('Sofia', 'Lopez', '7777-5555', 'sofia.lopez@medisys.com', 1),       -- Administrador
('Jorge', 'Salazar', '7777-6666', 'jorge.salazar@medisys.com', 2);    -- Médico
GO
PRINT 'Datos de Personal insertados.';

-- ===================================
-- 4. Insertar Médicos
-- ===================================
PRINT 'Insertando datos en Medico...';
-- Asumiendo que los ID_Personal para médicos son 1, 2, 6
-- Asumiendo que los ID_Especialidad son 1=Cardiología, 2=Pediatría, 3=Medicina General
INSERT INTO Medico (ID_Medico, Cedula_Profesional, ID_Especialidad) VALUES
(1, 'CP100200', 1), -- Carlos Rivera, Cardiología
(2, 'CP300400', 3), -- Ana Gomez, Medicina General
(6, 'CP500600', 2); -- Jorge Salazar, Pediatría
GO
PRINT 'Datos de Medico insertados.';

-- ===================================
-- 5. Insertar Usuarios
-- ===================================
PRINT 'Insertando datos en Usuario...';
-- Se debe usar un HASH de contraseña en un entorno real. PWDCOMPARE para verificar.
-- Ejemplo: HASHBYTES('SHA2_256', 'Password123!')
-- Por simplicidad, aquí se usa un texto que simula ser un hash.
INSERT INTO Usuario (ID_Personal, Username, PasswordHash, Activo) VALUES
-- Contraseña para crivera: 'password'
(1, 'crivera', '$2y$10$dNwwDUV4mZSnsOZ8BkSw/OqfFTXCvr/TdV9MhFTKmkHw58buuw07O', 1), -- Carlos Rivera (Médico)

-- Contraseña para agomez: 'AnaPass2@'
(2, 'agomez', '$2y$10$keORDgC9BCMfLMosDHHdCOcUejFbTCT3T9jLW9kUTGcA5JgCSup8e', 1), -- Ana Gomez (Médico)

-- Contraseña para lfernandez: 'LuciaPass3#'
(3, 'lfernandez', '$2y$10$q73SayfPPnvSl88QPX4IfeuHlFiPDNdixmvmor4tOqr8ulcjsZVCu', 1), -- Lucia Fernandez (Enfermera)

-- Contraseña para pmartinez: 'PedroPass4$'
(4, 'pmartinez', '$2y$10$2wQ9om7LCZ01OW.CmCuRR.YMf2RJvty0UHAGwvZ1Sq85HA2dqrhii', 1), -- Pedro Martinez (Recepcionista)

-- Contraseña para slopez: 'SofiaPass5%'
(5, 'slopez', '$2y$10$maA5ZKLZE4/iTtqaHHSfe.2uwZPAVQNbQNrsewcoV8Y3GNu.Sxw3G', 1); -- Sofia Lopez (Administrador)
GO
PRINT 'Datos de Usuario insertados.';

select * from BITACORA

select * from Cita
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
-- Asumiendo ID_Paciente: 1=Elena, 2=Juan, 3=Beatriz
-- Asumiendo ID_Medico: 1=Carlos Rivera (Cardiólogo), 2=Ana Gomez (Medicina General), 6=Jorge Salazar (Pediatra)
INSERT INTO Cita (Fecha_Hora, ID_Paciente, ID_Medico, Estado_Cita) VALUES
(DATEADD(day, 7, GETDATE()), 1, 1, 'Programada'),          -- Elena Morales con Carlos Rivera (Cardiología) en 7 días
(DATEADD(day, 3, GETDATE()), 2, 2, 'Confirmada'),          -- Juan Perez con Ana Gomez (Med. General) en 3 días
(DATEADD(day, 10, GETDATE()), 3, 6, 'Programada'),         -- Beatriz Castro con Jorge Salazar (Pediatría) en 10 días
(DATEADD(day, -2, GETDATE()), 1, 2, 'Realizada'),          -- Elena Morales con Ana Gomez (Med. General) hace 2 días
(DATEADD(day, -5, GETDATE()), 2, 1, 'Cancelada');          -- Juan Perez con Carlos Rivera (Cardiología) hace 5 días (Cancelada)
GO
PRINT 'Datos de Cita insertados.';

-- ===================================
-- 8. Insertar Visitas Médicas
-- ===================================
PRINT 'Insertando datos en Visita_Medica...';
-- ID_Cita 4 corresponde a la cita realizada de Elena Morales con Ana Gomez.
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

(3, 6, NULL, DATEADD(day, -1, GETDATE()), 0.95, 14.0, '90/60 mmHg', 110, 99, 37.5,
'Control de niño sano y vacunas.',
'Niña activa, reactiva. Buen estado de hidratación y nutrición. Desarrollo psicomotor acorde a edad. Se administran vacunas correspondientes al esquema.',
'Niña sana, control pediátrico.',
'Próximo control según calendario de vacunación. Consejos sobre alimentación complementaria.');
GO
PRINT 'Datos de Visita_Medica insertados.';


PRINT '=================================================='
PRINT 'Inserción de datos de ejemplo completada.'
PRINT '=================================================='
GO
