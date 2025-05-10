<?php
// Mostrar errores en desarrollo
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Incluir archivos requeridos
require_once '../includes/auth.php';
require_once '../includes/db.php';

// Validar inicio de sesión
// Asegúrate de que esta función exista en auth.php
requerirLogin();

// Obtener ID del paciente desde la URL
$idPaciente = $_GET['id'] ?? null;
if (!$idPaciente) {
    header('Location: pacientes.php');
    exit();
}

// Obtener información del paciente
$sql = "SELECT * FROM Paciente WHERE ID_Paciente = ?";
$paciente = obtenerFila(ejecutarConsulta($sql, [$idPaciente]));



if (!$paciente) {
    header('Location: pacientes.php');
    exit();
}

// Recuperar datos del formulario en caso de errores previos
$datosPaciente = $_SESSION['datos_paciente'] ?? $paciente;
$errores = $_SESSION['errores'] ?? array();
unset($_SESSION['datos_paciente'], $_SESSION['errores']);


$fechaNacimiento = '';

if (isset($datosPaciente['Fecha_Nacimiento'])) {
    $fecha = $datosPaciente['Fecha_Nacimiento'];

    if ($fecha instanceof DateTime) {
        $fechaNacimiento = $fecha->format('Y-m-d');
    } else {
        // Si viene como string, intenta convertirla a DateTime primero
        try {
            $fechaNacimiento = (new DateTime($fecha))->format('Y-m-d');
        } catch (Exception $e) {
            // Maneja formato inválido o error
            $fechaNacimiento = '';
        }
    }
}


$tituloPagina = "Editar Paciente";
require_once '../includes/header.php';
?>

<div class="container">
  <h1>Editar Paciente</h1>
  <?php echo "<!-- INICIO FORMULARIO -->"; ?>
  <form action="../logic/editar_paciente.php" method="POST">
    <input type="hidden" name="id_paciente" value="<?php echo htmlspecialchars($idPaciente); ?>">

    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">

      <!-- Nombre -->
      <div class="form-group">
        <label class="form-label">Nombre *</label>
        <input type="text" name="nombre" class="form-input <?php echo isset($errores['nombre']) ? 'invalid' : ''; ?>"
               placeholder="Nombre" required value="<?php echo htmlspecialchars($datosPaciente['Nombre'] ?? ''); ?>">
        <?php if (isset($errores['nombre'])): ?>
          <div class="form-error"><?php echo $errores['nombre']; ?></div>
        <?php endif; ?>
      </div>

      
      <!-- Apellido -->
      <div class="form-group">
        <label class="form-label">Apellido *</label>
        <input type="text" name="apellido" class="form-input <?php echo isset($errores['apellido']) ? 'invalid' : ''; ?>"
               placeholder="Apellido" required value="<?php echo htmlspecialchars($datosPaciente['Apellido'] ?? ''); ?>">
        <?php if (isset($errores['apellido'])): ?>
          <div class="form-error"><?php echo $errores['apellido']; ?></div>
        <?php endif; ?>
      </div>

      <!-- Fecha de Nacimiento -->
    <div class="form-group">
  <label class="form-label">Fecha de Nacimiento *</label>
  <input type="date" name="fecha_nacimiento"
         class="form-input <?php echo isset($errores['fecha_nacimiento']) ? 'invalid' : ''; ?>"
         required value="<?php echo htmlspecialchars($fechaNacimiento); ?>">
  <?php if (isset($errores['fecha_nacimiento'])): ?>
    <div class="form-error"><?php echo $errores['fecha_nacimiento']; ?></div>
  <?php endif; ?>
</div>

      <!-- Género -->
      <div class="form-group">
        <label class="form-label">Género *</label>
        <select name="sexo" class="form-select <?php echo isset($errores['sexo']) ? 'invalid' : ''; ?>" required>
          <option value="">Seleccione</option>
          <option value="Masculino" <?php echo ($datosPaciente['Sexo'] ?? '') == 'Masculino' ? 'selected' : ''; ?>>Masculino</option>
          <option value="Femenino" <?php echo ($datosPaciente['Sexo'] ?? '') == 'Femenino' ? 'selected' : ''; ?>>Femenino</option>
        </select>
        <?php if (isset($errores['sexo'])): ?>
          <div class="form-error"><?php echo $errores['sexo']; ?></div>
        <?php endif; ?>
      </div>

      <!-- Teléfono -->
      <div class="form-group">
        <label class="form-label">Teléfono</label>
        <input type="tel" name="telefono" class="form-input <?php echo isset($errores['telefono']) ? 'invalid' : ''; ?>"
               placeholder="Ej: 555-123-4567" value="<?php echo htmlspecialchars($datosPaciente['Telefono'] ?? ''); ?>">
        <?php if (isset($errores['telefono'])): ?>
          <div class="form-error"><?php echo $errores['telefono']; ?></div>
        <?php endif; ?>
      </div>

      <!-- Dirección -->
      <div class="form-group">
        <label class="form-label">Dirección</label>
        <textarea name="direccion" class="form-textarea <?php echo isset($errores['direccion']) ? 'invalid' : ''; ?>"
                  placeholder="Dirección"><?php echo htmlspecialchars($datosPaciente['Direccion'] ?? ''); ?></textarea>
        <?php if (isset($errores['direccion'])): ?>
          <div class="form-error"><?php echo $errores['direccion']; ?></div>
        <?php endif; ?>
      </div>

      <!-- Contacto de Emergencia -->
      <div class="form-group">
        <label class="form-label">Contacto de Emergencia</label>
        <input type="text" name="contacto_emergencia" class="form-input <?php echo isset($errores['contacto_emergencia']) ? 'invalid' : ''; ?>"
               placeholder="Nombre y relación" value="<?php echo htmlspecialchars($datosPaciente['Contacto_Emergencia'] ?? ''); ?>">
        <?php if (isset($errores['contacto_emergencia'])): ?>
          <div class="form-error"><?php echo $errores['contacto_emergencia']; ?></div>
        <?php endif; ?>
      </div>

      <!-- Teléfono de Emergencia -->
      <div class="form-group">
        <label class="form-label">Teléfono de Emergencia</label>
        <input type="tel" name="telefono_emergencia" class="form-input <?php echo isset($errores['telefono_emergencia']) ? 'invalid' : ''; ?>"
               placeholder="Ej: 555-123-4567" value="<?php echo htmlspecialchars($datosPaciente['Telefono_Contacto_Emergencia'] ?? ''); ?>">
        <?php if (isset($errores['telefono_emergencia'])): ?>
          <div class="form-error"><?php echo $errores['telefono_emergencia']; ?></div>
        <?php endif; ?>
      </div>

    </div>

    <div class="form-actions mt-4">
      <a href="paciente_detalle.php?id=<?php echo $idPaciente; ?>" class="button button-secondary">Cancelar</a>
      <button type="submit" class="button">Guardar Cambios</button>
    </div>

    <?php echo "<!-- FIN FORMULARIO -->"; ?>
  </form>
</div>

<?php require_once '../includes/footer.php'; ?>
