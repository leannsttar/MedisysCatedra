/* ==========================================================================
Triggers de Auditoría para la tabla Cita
Propósito: Registrar automáticamente en la tabla BITACORA todas las operaciones INSERT, UPDATE y DELETE realizadas sobre la tabla Cita.
==========================================================================

Cada trigger inserta un registro en la tabla BITACORA con la siguiente información:
- Usuario_sistema: Usuario de SQL Server que realizó la operación.
- Nombre_tabla: Siempre 'Cita' para identificar la tabla afectada.
- Transaccion: Tipo de operación realizada ('INSERT', 'UPDATE', 'DELETE').
- Detalle_PK: Clave primaria afectada (ID_Cita).

Esto permite llevar un historial de auditoría de todas las modificaciones sobre la tabla Cita.

Ejemplo de registro en BITACORA tras un INSERT:
| Usuario_sistema | Nombre_tabla | Transaccion | Detalle_PK      |
|-----------------|--------------|-------------|-----------------|
| admin           | Cita         | INSERT      | ID_Cita: 15     |

========================================================================== */

PRINT 'Creando trigger trg_Cita_Audit_Insert...';
GO
CREATE TRIGGER trg_Cita_Audit_Insert
ON Cita
AFTER INSERT
AS
BEGIN
    IF @@ROWCOUNT = 0 RETURN;
    SET NOCOUNT ON;
    INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK)
    SELECT SYSTEM_USER, 'Cita', 'INSERT', CONCAT('ID_Cita: ', i.ID_Cita)
    FROM inserted i;
END;
GO

PRINT 'Creando trigger trg_Cita_Audit_Update...';
GO
CREATE TRIGGER trg_Cita_Audit_Update
ON Cita
AFTER UPDATE
AS
BEGIN
    IF @@ROWCOUNT = 0 RETURN;
    SET NOCOUNT ON;
    INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK)
    SELECT SYSTEM_USER, 'Cita', 'UPDATE', CONCAT('ID_Cita: ', i.ID_Cita)
    FROM inserted i;
END;
GO

PRINT 'Creando trigger trg_Cita_Audit_Delete...';
GO
CREATE TRIGGER trg_Cita_Audit_Delete
ON Cita
AFTER DELETE
AS
BEGIN
    IF @@ROWCOUNT = 0 RETURN;
    SET NOCOUNT ON;
    INSERT INTO BITACORA (Usuario_sistema, Nombre_tabla, Transaccion, Detalle_PK)
    SELECT SYSTEM_USER, 'Cita', 'DELETE', CONCAT('ID_Cita: ', d.ID_Cita)
    FROM deleted d;
END;
GO

PRINT 'Triggers para Cita creados.';