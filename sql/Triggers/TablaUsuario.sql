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