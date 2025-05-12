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