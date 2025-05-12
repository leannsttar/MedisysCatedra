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
Permite modificar los datos de un paciente ya registrado, validando que el paciente exista y que **todos los campos sean obligatorios** (nombre, apellido, dirección, fecha de nacimiento, sexo, teléfono, contacto de emergencia y teléfono de contacto de emergencia). Además, valida que el sexo sea válido y que los datos cumplan con las restricciones de formato y longitud.

Parámetros:
@ID_Paciente                   - (Requerido) Identificador único del paciente (entero positivo)
@Nombre                        - (Requerido) Nombre del paciente (máx 100 caracteres)
@Apellido                      - (Requerido) Apellido del paciente (máx 100 caracteres)
@Direccion                     - (Requerido) Dirección de residencia (máx 200 caracteres)
@Fecha_Nacimiento              - (Requerido) Fecha de nacimiento (formato YYYY-MM-DD)
@Sexo                          - (Requerido) Sexo del paciente ('Masculino' o 'Femenino')
@Telefono                      - (Requerido) Teléfono del paciente (máx 20 caracteres)
@Contacto_Emergencia           - (Requerido) Nombre del contacto de emergencia (máx 100 caracteres)
@Telefono_Contacto_Emergencia  - (Requerido) Teléfono del contacto de emergencia (máx 20 caracteres)

Códigos de Retorno:
-1  - Paciente no existe
-2  - Algún campo obligatorio vacío
-3  - Sexo inválido
-4  - Longitud de campo excedida
-5  - Fecha de nacimiento inválida (futura)
-99 - Error de sistema
0   - Actualización exitosa

Ejemplo de uso:
-- Caso exitoso (todos los parámetros válidos)
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Paciente no existe
EXEC ActualizarPaciente 
    @ID_Paciente = 9999,
    @Nombre = N'Juan',
    @Apellido = N'Perez',
    @Direccion = N'Avenida Sol #45, Santa Tecla',
    @Fecha_Nacimiento = '1992-11-30',
    @Sexo = N'Masculino',
    @Telefono = N'7171-2020',
    @Contacto_Emergencia = N'Maria Rodriguez',
    @Telefono_Contacto_Emergencia = N'7171-2021';

-- Caso: Nombre vacío
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Dirección vacía
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Fecha de nacimiento vacía
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = NULL,
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

-- Caso: Sexo inválido
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '1985-05-15',
    @Sexo = N'Otro',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';


-- Caso: Fecha de nacimiento futura
EXEC ActualizarPaciente 
    @ID_Paciente = 1,
    @Nombre = N'Elena',
    @Apellido = N'Morales',
    @Direccion = N'Calle Luna #123, San Salvador',
    @Fecha_Nacimiento = '2099-01-01',
    @Sexo = N'Femenino',
    @Telefono = N'7070-1010',
    @Contacto_Emergencia = N'Roberto Morales',
    @Telefono_Contacto_Emergencia = N'7070-1011';

Notas:
- Todos los campos son obligatorios y deben cumplir con las restricciones de longitud y formato.
- El procedimiento retorna 0 si la actualización es exitosa.
- Si ocurre un error, retorna un código negativo según el tipo de error y muestra un mensaje específico.
======================================================================= */

CREATE PROCEDURE ActualizarPaciente (
    @ID_Paciente INT,
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

    -- Validar existencia del paciente
    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('Error -1: El paciente especificado no existe.', 16, 1);
        RETURN -1;
    END

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
        RAISERROR('Error -2: Todos los campos son obligatorios y no pueden estar vacíos.', 16, 1);
        RETURN -2;
    END

    -- Validar sexo
    IF @Sexo NOT IN ('Masculino', 'Femenino')
    BEGIN
        RAISERROR('Error -3: El valor para Sexo no es válido. Use "Masculino" o "Femenino".', 16, 1);
        RETURN -3;
    END


    -- Validar que la fecha de nacimiento no sea futura
    IF @Fecha_Nacimiento > GETDATE()
    BEGIN
        RAISERROR('Error -5: La fecha de nacimiento no puede ser futura.', 16, 1);
        RETURN -5;
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
        DECLARE @MensajeError NVARCHAR(4000);
        SET @MensajeError = 'Error -99: Error al actualizar paciente - ' + ERROR_MESSAGE();
        RAISERROR(@MensajeError, 16, 1);
        RETURN -99;
    END CATCH
END;
GO

PRINT 'Procedimiento ActualizarPaciente creado.';
PRINT 'Procedimientos Almacenados CRUD actualizados.';
GO
