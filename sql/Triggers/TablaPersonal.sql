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