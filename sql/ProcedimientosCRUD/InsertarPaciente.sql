PRINT 'Creando procedimiento InsertarPaciente...';
GO
/* ======================================================================
Nombre: InsertarPaciente
Propósito: Inserta un nuevo paciente en la base de datos con validación básica de datos.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Permite registrar un nuevo paciente en el sistema, validando que el nombre y apellido sean obligatorios y que el sexo, si se proporciona, sea válido.

Parámetros:
@Nombre                        - (Requerido) Nombre del paciente (máx 100 caracteres)
@Apellido                      - (Requerido) Apellido del paciente (máx 100 caracteres)
@Direccion                     - Dirección de residencia (opcional)
@Fecha_Nacimiento              - Fecha de nacimiento (opcional, formato YYYY-MM-DD)
@Sexo                          - Sexo del paciente ('Masculino' o 'Femenino', opcional)
@Telefono                      - Teléfono del paciente (opcional)
@Contacto_Emergencia           - Nombre del contacto de emergencia (opcional)
@Telefono_Contacto_Emergencia  - Teléfono del contacto de emergencia (opcional)

Códigos de Retorno:
-1  - Nombre o apellido vacío
-2  - Sexo inválido
-99 - Error de sistema
Otro valor: ID del paciente insertado (éxito)

Ejemplo de uso:
-- Caso exitoso (todos los parámetros)
DECLARE @ID INT;
EXEC @ID = InsertarPaciente 
    @Nombre = N'Juan',
    @Apellido = N'Pérez',
    @Direccion = N'Calle 123',
    @Fecha_Nacimiento = '1990-01-01',
    @Sexo = N'Masculino',
    @Telefono = N'7777-8888',
    @Contacto_Emergencia = N'María Pérez',
    @Telefono_Contacto_Emergencia = N'7777-9999';

-- Caso: Nombre vacío
EXEC InsertarPaciente 
    @Nombre = N'',
    @Apellido = N'Pérez',
    @Direccion = N'Calle 123',
    @Fecha_Nacimiento = '1990-01-01',
    @Sexo = N'Masculino',
    @Telefono = N'7777-8888',
    @Contacto_Emergencia = N'María Pérez',
    @Telefono_Contacto_Emergencia = N'7777-9999';

-- Caso: Sexo inválido
EXEC InsertarPaciente 
    @Nombre = N'Juan',
    @Apellido = N'Pérez',
    @Direccion = N'Calle 123',
    @Fecha_Nacimiento = '1990-01-01',
    @Sexo = N'Otro',
    @Telefono = N'7777-8888',
    @Contacto_Emergencia = N'María Pérez',
    @Telefono_Contacto_Emergencia = N'7777-9999';

Notas:
- El procedimiento retorna el ID del paciente insertado si la operación es exitosa.
- Si ocurre un error, retorna un código negativo según el tipo de error.
======================================================================= */
CREATE PROCEDURE InsertarPaciente (
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
    IF LTRIM(RTRIM(ISNULL(@Nombre, ''))) = '' OR LTRIM(RTRIM(ISNULL(@Apellido, ''))) = '' BEGIN
        RAISERROR('El nombre y el apellido del paciente son obligatorios.', 16, 1);
        RETURN -1;
    END
    IF @Sexo IS NOT NULL AND @Sexo NOT IN ('Masculino', 'Femenino') BEGIN
        RAISERROR('El valor para Sexo no es válido. Use "Masculino" o "Femenino".', 16, 1);
        RETURN -2;
    END
    BEGIN TRY
        INSERT INTO Paciente (Nombre, Apellido, Direccion, Fecha_Nacimiento, Sexo, Telefono, Contacto_Emergencia, Telefono_Contacto_Emergencia)
        VALUES (@Nombre, @Apellido, @Direccion, @Fecha_Nacimiento, @Sexo, @Telefono, @Contacto_Emergencia, @Telefono_Contacto_Emergencia);
        RETURN SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        RAISERROR('Error al insertar paciente.', 16, 1);
        RETURN -99;
    END CATCH
END;
GO
PRINT 'Procedimiento InsertarPaciente creado.';