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