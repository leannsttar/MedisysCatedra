<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Nuevo Paciente";
require_once '../includes/header.php';

// Recuperar datos del formulario si hay errores
$datosPaciente = $_SESSION['datos_paciente'] ?? array();
$errores = $_SESSION['errores'] ?? array();
unset($_SESSION['datos_paciente']);
unset($_SESSION['errores']);
?>

<div class="container">
  <h1>Registrar Nuevo Paciente</h1>
  
  <?php if (isset($errores['general'])): ?>
  <div class="alert alert-danger"><?php echo $errores['general']; ?></div>
  <?php endif; ?>
  
  <form method="POST" action="../logic/registrar-paciente.php">
    <div class="card">
      <div class="card-header">
        <div class="card-title">Información Personal</div>
        <div class="text-xs text-muted">* Campos obligatorios</div>
      </div>
      <div class="card-content">
        <div class="grid grid-cols-1 grid-md-cols-2 gap-4">
          <div class="form-group">
            <label class="form-label">Nombre Completo *</label>
            <input type="text" name="nombre" class="form-input <?php echo isset($errores['nombre']) ? 'invalid' : ''; ?>" 
                   placeholder="Nombre y apellidos" required value="<?php echo htmlspecialchars($datosPaciente['nombre'] ?? ''); ?>">
            <?php if (isset($errores['nombre'])): ?>
            <div class="form-error"><?php echo $errores['nombre']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Fecha de Nacimiento *</label>
            <input type="date" name="fecha_nacimiento" class="form-input <?php echo isset($errores['fecha_nacimiento']) ? 'invalid' : ''; ?>" 
                   required value="<?php echo htmlspecialchars($datosPaciente['fecha_nacimiento'] ?? ''); ?>">
            <?php if (isset($errores['fecha_nacimiento'])): ?>
            <div class="form-error"><?php echo $errores['fecha_nacimiento']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Género *</label>
            <select name="sexo" class="form-select" required>
              <option value="">Seleccionar género...</option>
              <option value="M" <?php echo ($datosPaciente['sexo'] ?? '') == 'M' ? 'selected' : ''; ?>>Masculino</option>
              <option value="F" <?php echo ($datosPaciente['sexo'] ?? '') == 'F' ? 'selected' : ''; ?>>Femenino</option>
              <option value="O" <?php echo ($datosPaciente['sexo'] ?? '') == 'O' ? 'selected' : ''; ?>>Otro</option>
            </select>
          </div>
          
          <div class="form-group">
            <label class="form-label">Número de Teléfono *</label>
            <input type="tel" name="telefono" class="form-input <?php echo isset($errores['telefono']) ? 'invalid' : ''; ?>" 
                   placeholder="Ej: 555-123-4567" required value="<?php echo htmlspecialchars($datosPaciente['telefono'] ?? ''); ?>">
            <?php if (isset($errores['telefono'])): ?>
            <div class="form-error"><?php echo $errores['telefono']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Correo Electrónico</label>
            <input type="email" name="correo" class="form-input" 
                   placeholder="correo@ejemplo.com" value="<?php echo htmlspecialchars($datosPaciente['correo'] ?? ''); ?>">
          </div>
          
          <div class="form-group">
            <label class="form-label">Dirección</label>
            <input type="text" name="direccion" class="form-input" 
                   placeholder="Calle, número, colonia" value="<?php echo htmlspecialchars($datosPaciente['direccion'] ?? ''); ?>">
          </div>
        </div>
        
        <div class="grid grid-cols-1 grid-md-cols-2 gap-4 mt-4">
          <div class="form-group">
            <label class="form-label">Contacto de Emergencia</label>
            <input type="text" name="contacto_emergencia" class="form-input" 
                   placeholder="Nombre y relación" value="<?php echo htmlspecialchars($datosPaciente['contacto_emergencia'] ?? ''); ?>">
          </div>
          
          <div class="form-group">
            <label class="form-label">Teléfono de Emergencia</label>
            <input type="tel" name="telefono_emergencia" class="form-input" 
                   placeholder="Ej: 555-123-4567" value="<?php echo htmlspecialchars($datosPaciente['telefono_emergencia'] ?? ''); ?>">
          </div>
        </div>
        
        <div class="form-group mt-4">
          <label class="form-label">Notas Adicionales</label>
          <textarea name="notas" class="form-textarea" placeholder="Alergias, condiciones preexistentes, etc."><?php echo htmlspecialchars($datosPaciente['notas'] ?? ''); ?></textarea>
        </div>
        
        <div class="form-actions">
          <a href="pacientes.php" class="button button-secondary">Cancelar</a>
          <button type="submit" class="button">Guardar Paciente</button>
        </div>
      </div>
    </div>
  </form>
</div>

<?php require_once '../includes/footer.php'; ?>