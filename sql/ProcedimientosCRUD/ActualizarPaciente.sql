PRINT 'Creando procedimiento ActualizarPaciente...';
GO

/* ======================================================================
Nombre: ActualizarPaciente
Propósito: Actualiza los datos de un paciente existente en la base de datos, validando exhaustivamente los datos de entrada.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Permite modificar los datos de un paciente ya registrado, validando que el paciente exista, que el nombre y apellido sean obligatorios y que el sexo, si se proporciona, sea válido.

Parámetros:
@ID_Paciente                   - (Requerido) Identificador único del paciente (entero positivo)
@Nombre                        - (Requerido) Nombre del paciente (máx 100 caracteres)
@Apellido                      - (Requerido) Apellido del paciente (máx 100 caracteres)
@Direccion                     - Dirección de residencia (opcional)
@Fecha_Nacimiento              - Fecha de nacimiento (opcional, formato YYYY-MM-DD)
@Sexo                          - Sexo del paciente ('Masculino' o 'Femenino', opcional)
@Telefono                      - Teléfono del paciente (opcional)
@Contacto_Emergencia           - Nombre del contacto de emergencia (opcional)
@Telefono_Contacto_Emergencia  - Teléfono del contacto de emergencia (opcional)

Códigos de Retorno:
-1  - Paciente no existe
-2  - Nombre o apellido vacío
-3  - Sexo inválido
-99 - Error de sistema
0   - Actualización exitosa

Ejemplo de uso:
-- Caso exitoso (todos los parámetros)
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Juan',
    @Apellido = N'Pérez',
    @Direccion = N'Calle 123',
    @Fecha_Nacimiento = '1990-01-01',
    @Sexo = N'Masculino',
    @Telefono = N'7777-8888',
    @Contacto_Emergencia = N'María Pérez',
    @Telefono_Contacto_Emergencia = N'7777-9999';

-- Caso: Paciente no existe
EXEC ActualizarPaciente 
    @ID_Paciente = 9999,
    @Nombre = N'Juan',
    @Apellido = N'Pérez',
    @Direccion = N'Calle 123',
    @Fecha_Nacimiento = '1990-01-01',
    @Sexo = N'Masculino',
    @Telefono = N'7777-8888',
    @Contacto_Emergencia = N'María Pérez',
    @Telefono_Contacto_Emergencia = N'7777-9999';

-- Caso: Nombre vacío
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'',
    @Apellido = N'Pérez',
    @Direccion = N'Calle 123',
    @Fecha_Nacimiento = '1990-01-01',
    @Sexo = N'Masculino',
    @Telefono = N'7777-8888',
    @Contacto_Emergencia = N'María Pérez',
    @Telefono_Contacto_Emergencia = N'7777-9999';

-- Caso: Sexo inválido
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Juan',
    @Apellido = N'Pérez',
    @Direccion = N'Calle 123',
    @Fecha_Nacimiento = '1990-01-01',
    @Sexo = N'Otro',
    @Telefono = N'7777-8888',
    @Contacto_Emergencia = N'María Pérez',
    @Telefono_Contacto_Emergencia = N'7777-9999';

Notas:
- El procedimiento retorna 0 si la actualización es exitosa.
- Si ocurre un error, retorna un código negativo según el tipo de error.
======================================================================= */

CREATE PROCEDURE ActualizarPaciente (
    @ID_Paciente INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Direccion NVARCHAR(200) = NULL,
    @Fecha_Nacimiento DATE = NULL,
    @Sexo NVARCHAR(10) = NULL,
    @Telefono NVARCHAR(20) = NULL,
    @Contacto_Emergencia NVARCHAR(100) = NULL,
    @Telefono_Contacto_Emergencia NVARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('El paciente especificado no existe.', 16, 1);
        RETURN -1; -- Error: Paciente no existe
    END

    IF LTRIM(RTRIM(ISNULL(@Nombre, ''))) = '' OR LTRIM(RTRIM(ISNULL(@Apellido, ''))) = '' BEGIN
        RAISERROR('El nombre y el apellido del paciente son obligatorios.', 16, 1);
        RETURN -2; -- Error: Campos obligatorios vacíos
    END

    IF @Sexo IS NOT NULL AND @Sexo NOT IN ('Masculino', 'Femenino') BEGIN
        RAISERROR('El valor para Sexo no es válido. Use "Masculino" o "Femenino".', 16, 1);
        RETURN -3; -- Error: Valor de sexo inválido
    END

    BEGIN TRY
        UPDATE Paciente SET
            Nombre = @Nombre,
            Apellido = @Apellido,
            Direccion = @Direccion,
            Fecha_Nacimiento = @Fecha_Nacimiento,
            Sexo = @Sexo,
            Telefono = @Telefono,
            Contacto_Emergencia = @Contacto_Emergencia,
            Telefono_Contacto_Emergencia = @Telefono_Contacto_Emergencia
        WHERE ID_Paciente = @ID_Paciente;

        RETURN 0; -- Éxito
    END TRY
    BEGIN CATCH
        RAISERROR('Error al actualizar paciente.', 16, 1);
        RETURN -99; -- Error SQL genérico
    END CATCH
END;
GO
PRINT 'Procedimiento ActualizarPaciente creado.';
PRINT 'Procedimientos Almacenados CRUD actualizados.';
GO
