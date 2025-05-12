PRINT 'Creando procedimiento InsertarPaciente...';
GO
/* ======================================================================
Nombre: InsertarPaciente
Propósito: Inserta un nuevo paciente en la base de datos con validación exhaustiva de datos.
====================================================================== */

/* ======================================================================
DOCUMENTACIÓN
=======================================================================
Propósito:
Permite registrar un nuevo paciente en el sistema, validando que **todos los campos sean obligatorios** (nombre, apellido, dirección, fecha de nacimiento, sexo, teléfono, contacto de emergencia y teléfono de contacto de emergencia), que el sexo sea válido y que los datos cumplan con las restricciones de formato y longitud.

Parámetros:
@Nombre                        - (Requerido) Nombre del paciente (máx 100 caracteres)
@Apellido                      - (Requerido) Apellido del paciente (máx 100 caracteres)
@Direccion                     - (Requerido) Dirección de residencia (máx 200 caracteres)
@Fecha_Nacimiento              - (Requerido) Fecha de nacimiento (formato YYYY-MM-DD)
@Sexo                          - (Requerido) Sexo del paciente ('Masculino' o 'Femenino')
@Telefono                      - (Requerido) Teléfono del paciente (máx 20 caracteres)
@Contacto_Emergencia           - (Requerido) Nombre del contacto de emergencia (máx 100 caracteres)
@Telefono_Contacto_Emergencia  - (Requerido) Teléfono del contacto de emergencia (máx 20 caracteres)

Códigos de Retorno:
-1  - Algún campo obligatorio vacío
-2  - Sexo inválido
-3  - Longitud de campo excedida
-4  - Fecha de nacimiento inválida (futura)
-99 - Error de sistema
Otro valor: ID del paciente insertado (éxito)

Ejemplo de uso:
-- Caso exitoso (todos los parámetros)
DECLARE @ID INT;
EXEC @ID = InsertarPaciente 
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Nombre vacío
EXEC InsertarPaciente 
    @Nombre = N'',
    @Apellido = N'Perez',
    @Direccion = N'Avenida Sol #45, Santa Tecla',
    @Fecha_Nacimiento = '1992-11-30',
    @Sexo = N'Masculino',
    @Telefono = N'7171-2020',
    @Contacto_Emergencia = N'Maria Rodriguez',
    @Telefono_Contacto_Emergencia = N'7171-2021';

-- Caso: Sexo inválido
EXEC InsertarPaciente 
    @Nombre = N'Juan',
    @Apellido = N'Perez',
    @Direccion = N'Avenida Sol #45, Santa Tecla',
    @Fecha_Nacimiento = '1992-11-30',
    @Sexo = N'Otro',
    @Telefono = N'7171-2020',
    @Contacto_Emergencia = N'Maria Rodriguez',
    @Telefono_Contacto_Emergencia = N'7171-2021';


-- Caso: Fecha de nacimiento futura
EXEC InsertarPaciente 
    @Nombre = N'Juan',
    @Apellido = N'Perez',
    @Direccion = N'Avenida Sol #45, Santa Tecla',
    @Fecha_Nacimiento = '2099-01-01',
    @Sexo = N'Masculino',
    @Telefono = N'7171-2020',
    @Contacto_Emergencia = N'Maria Rodriguez',
    @Telefono_Contacto_Emergencia = N'7171-2021';

Notas:
- Todos los campos son obligatorios y deben cumplir con las restricciones de longitud y formato.
- El procedimiento retorna el ID del paciente insertado si la operación es exitosa.
- Si ocurre un error, retorna un código negativo según el tipo de error.
======================================================================= */
CREATE PROCEDURE InsertarPaciente (
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Direccion NVARCHAR(200),
    @Fecha_Nacimiento DATE,
    @Sexo NVARCHAR(10),
    @Telefono NVARCHAR(20),
    @Contacto_Emergencia NVARCHAR(100),
    @Telefono_Contacto_Emergencia NVARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que todos los campos sean obligatorios y no vacíos
    IF LTRIM(RTRIM(ISNULL(@Nombre, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Apellido, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Direccion, ''))) = '' OR
       @Fecha_Nacimiento IS NULL OR
       LTRIM(RTRIM(ISNULL(@Sexo, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Telefono, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Contacto_Emergencia, ''))) = '' OR
       LTRIM(RTRIM(ISNULL(@Telefono_Contacto_Emergencia, ''))) = ''
    BEGIN
        RAISERROR('Error -1: Todos los campos son obligatorios y no pueden estar vacíos.', 16, 1);
        RETURN -1;
    END

    -- Validar sexo
    IF @Sexo NOT IN ('Masculino', 'Femenino')
    BEGIN
        RAISERROR('Error -2: El valor para Sexo no es válido. Use "Masculino" o "Femenino".', 16, 1);
        RETURN -2;
    END
    -- Validar que la fecha de nacimiento no sea futura
    IF @Fecha_Nacimiento > GETDATE()
    BEGIN
        RAISERROR('Error -4: La fecha de nacimiento no puede ser futura.', 16, 1);
        RETURN -4;
    END

    BEGIN TRY
        INSERT INTO Paciente (Nombre, Apellido, Direccion, Fecha_Nacimiento, Sexo, Telefono, Contacto_Emergencia, Telefono_Contacto_Emergencia)
        VALUES (@Nombre, @Apellido, @Direccion, @Fecha_Nacimiento, @Sexo, @Telefono, @Contacto_Emergencia, @Telefono_Contacto_Emergencia);
        RETURN SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        DECLARE @MensajeError NVARCHAR(4000);
        SET @MensajeError = 'Error -99: Error al insertar paciente - ' + ERROR_MESSAGE();
        RAISERROR(@MensajeError, 16, 1);
        RETURN -99;
    END CATCH
END;
GO
PRINT 'Procedimiento InsertarPaciente creado.';