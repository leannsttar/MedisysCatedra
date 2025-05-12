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