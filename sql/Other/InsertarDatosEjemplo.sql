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
(1, 'crivera', '$2y$10$dNwwDUV4mZSnsOZ8BkSw/OqfFTXCvr/TdV9MhFTKmkHw58buuw07O', 1),
(2, 'agomez', '$2y$10$keORDgC9BCMfLMosDHHdCOcUejFbTCT3T9jLW9kUTGcA5JgCSup8e', 1),
(3, 'lfernandez', '$2y$10$q73SayfPPnvSl88QPX4IfeuHlFiPDNdixmvmor4tOqr8ulcjsZVCu', 1),
(4, 'slopez', '$2y$10$maA5ZKLZE4/iTtqaHHSfe.2uwZPAVQNbQNrsewcoV8Y3GNu.Sxw3G', 1);
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
