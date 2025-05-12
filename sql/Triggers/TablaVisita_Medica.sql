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