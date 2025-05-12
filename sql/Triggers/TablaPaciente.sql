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
