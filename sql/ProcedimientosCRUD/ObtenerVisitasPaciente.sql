/* ======================================================================
Nombre: ObtenerVisitasPaciente
Propósito: Devuelve la lista de visitas médicas asociadas a un paciente específico.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Obtiene todas las visitas médicas registradas para un paciente, mostrando información relevante del médico y especialidad.

Parámetros:
@ID_Paciente - (Requerido) Identificador único del paciente (entero positivo)

Códigos de Retorno:
 0  - Consulta exitosa
-1  - Paciente no existe
-99 - Error de sistema

Ejemplo de uso:
-- Caso exitoso
EXEC ObtenerVisitasPaciente @ID_Paciente = 1;

-- Caso: Paciente no existe
EXEC ObtenerVisitasPaciente @ID_Paciente = 9999;

Notas:
- El parámetro ID_Paciente es obligatorio y debe existir en la tabla Paciente.
- Si el paciente no existe, retorna -1 y muestra un mensaje de error.
- Si ocurre un error de sistema, retorna -99.
======================================================================= */
-- CRUD: READ (Obtener Visitas de un Paciente)
PRINT 'Creando procedimiento ObtenerVisitasPaciente...';
GO
CREATE PROCEDURE ObtenerVisitasPaciente (
    @ID_Paciente INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('El paciente especificado no existe.', 16, 1);
        RETURN -1;
    END

    BEGIN TRY
        SELECT v.ID_Visita, 
               v.Fecha_Visita, 
               CONCAT(p.Nombre, ' ', p.Apellido) AS Medico, -- Combina el nombre y apellido del médico
               e.Nombre_Especialidad, 
               v.Motivo_Consulta, 
               v.Diagnostico
        FROM Visita_Medica v
        INNER JOIN Medico m ON v.ID_Medico = m.ID_Medico
        INNER JOIN Personal p ON m.ID_Medico = p.ID_Personal
        INNER JOIN Especialidad e ON m.ID_Especialidad = e.ID_Especialidad
        WHERE v.ID_Paciente = @ID_Paciente
        ORDER BY v.Fecha_Visita DESC;

        RETURN 0; -- Éxito
    END TRY
    BEGIN CATCH
        DECLARE @MensajeError NVARCHAR(4000);
        SET @MensajeError = 'Error 99: Error al obtener visitas del paciente - ' + ERROR_MESSAGE();
        RAISERROR(@MensajeError, 16, 1);
        RETURN -99;
    END CATCH
END;
GO
PRINT 'Procedimiento ObtenerVisitasPaciente creado.';
