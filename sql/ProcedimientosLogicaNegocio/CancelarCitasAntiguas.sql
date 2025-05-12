/* ======================================================================
Nombre: CancelarCitasAntiguas
Propósito: Cancela automáticamente todas las citas pasadas que no han sido realizadas ni canceladas.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Este procedimiento recorre todas las citas cuya fecha/hora ya pasó y que aún no tienen estado 'Realizada' ni 'Cancelada', y las marca como 'Cancelada'.

Parámetros:
(No recibe parámetros)


-- Asegúrate de tener un paciente y un médico válidos
DECLARE @PacienteID INT = 1; -- Reemplaza con un ID real
DECLARE @MedicoID INT = 1;   -- Reemplaza con un ID real

-- Insertar cita en el pasado
INSERT INTO Cita (Fecha_Hora, ID_Paciente, ID_Medico, Estado_Cita)
VALUES (DATEADD(DAY, -5, GETDATE()), @PacienteID, @MedicoID, 'Programada');

select * from Cita

-- EXEC CancelarCitasAntiguas;

Notas:
- Solo afecta citas con Fecha_Hora menor a la fecha/hora actual y cuyo Estado_Cita no sea 'Realizada' ni 'Cancelada'.
- El procedimiento utiliza un cursor simple para recorrer y actualizar cada cita antigua.
- No retorna ningún valor explícito.
======================================================================= */

CREATE PROCEDURE CancelarCitasAntiguas
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ID_Cita INT;

    -- Cursor simple para recorrer las citas antiguas no realizadas ni canceladas
    DECLARE citas_cursor CURSOR FOR
        SELECT ID_Cita
        FROM Cita
        WHERE Fecha_Hora < GETDATE()
          AND Estado_Cita NOT IN ('Realizada', 'Cancelada');

    OPEN citas_cursor;
    FETCH NEXT FROM citas_cursor INTO @ID_Cita;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Actualiza el estado de la cita a 'Cancelada'
        UPDATE Cita
        SET Estado_Cita = 'Cancelada'
        WHERE ID_Cita = @ID_Cita;

        -- Siguiente cita
        FETCH NEXT FROM citas_cursor INTO @ID_Cita;
    END

    CLOSE citas_cursor;
    DEALLOCATE citas_cursor;
END;
