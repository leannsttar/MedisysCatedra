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