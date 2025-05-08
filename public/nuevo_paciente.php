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
  
  <form method="POST" action="../logic/registrar_paciente.php" class="form">
    <div class="card">
      <div class="card-header">
        <div class="card-title">Información Personal</div>
        <div class="text-xs text-muted">* Campos obligatorios</div>
      </div>
      <div class="card-content">
        <div class="grid grid-cols-1 grid-md-cols-2 gap-4">
          <div class="form-group">
            <label class="form-label">Nombre *</label>
            <input type="text" name="nombre" class="form-input <?php echo isset($errores['nombre']) ? 'invalid' : ''; ?>" 
                   placeholder="Nombre" required value="<?php echo htmlspecialchars($datosPaciente['nombre'] ?? ''); ?>">
            <?php if (isset($errores['nombre'])): ?>
            <div class="form-error"><?php echo $errores['nombre']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Apellido *</label>
            <input type="text" name="apellido" class="form-input <?php echo isset($errores['apellido']) ? 'invalid' : ''; ?>" 
                   placeholder="Apellido" required value="<?php echo htmlspecialchars($datosPaciente['apellido'] ?? ''); ?>">
            <?php if (isset($errores['apellido'])): ?>
            <div class="form-error"><?php echo $errores['apellido']; ?></div>
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
            <select name="sexo" class="form-select <?php echo isset($errores['sexo']) ? 'invalid' : ''; ?>" required>
              <option value="">Seleccionar género...</option>
              <option value="Masculino" <?php echo ($datosPaciente['sexo'] ?? '') == 'Masculino' ? 'selected' : ''; ?>>Masculino</option>
              <option value="Femenino" <?php echo ($datosPaciente['sexo'] ?? '') == 'Femenino' ? 'selected' : ''; ?>>Femenino</option>
            </select>
            <?php if (isset($errores['sexo'])): ?>
            <div class="form-error"><?php echo $errores['sexo']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Número de Teléfono</label>
            <input type="tel" name="telefono" class="form-input <?php echo isset($errores['telefono']) ? 'invalid' : ''; ?>" 
                   placeholder="Ej: 555-123-4567" value="<?php echo htmlspecialchars($datosPaciente['telefono'] ?? ''); ?>">
            <?php if (isset($errores['telefono'])): ?>
            <div class="form-error"><?php echo $errores['telefono']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Dirección</label>
            <input type="text" name="direccion" class="form-input <?php echo isset($errores['direccion']) ? 'invalid' : ''; ?>" 
                   placeholder="Calle, número, colonia" value="<?php echo htmlspecialchars($datosPaciente['direccion'] ?? ''); ?>">
            <?php if (isset($errores['direccion'])): ?>
            <div class="form-error"><?php echo $errores['direccion']; ?></div>
            <?php endif; ?>
          </div>
        </div>
        
        <div class="grid grid-cols-1 grid-md-cols-2 gap-4 mt-4">
          <div class="form-group">
            <label class="form-label">Contacto de Emergencia</label>
            <input type="text" name="contacto_emergencia" class="form-input <?php echo isset($errores['contacto_emergencia']) ? 'invalid' : ''; ?>" 
                   placeholder="Nombre y relación" value="<?php echo htmlspecialchars($datosPaciente['contacto_emergencia'] ?? ''); ?>">
            <?php if (isset($errores['contacto_emergencia'])): ?>
            <div class="form-error"><?php echo $errores['contacto_emergencia']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Teléfono de Emergencia</label>
            <input type="tel" name="telefono_emergencia" class="form-input <?php echo isset($errores['telefono_emergencia']) ? 'invalid' : ''; ?>" 
                   placeholder="Ej: 555-123-4567" value="<?php echo htmlspecialchars($datosPaciente['telefono_emergencia'] ?? ''); ?>">
            <?php if (isset($errores['telefono_emergencia'])): ?>
            <div class="form-error"><?php echo $errores['telefono_emergencia']; ?></div>
            <?php endif; ?>
          </div>
        </div>
        
        <div class="form-group mt-4">
          <label class="form-label">Notas Adicionales</label>
          <textarea name="notas" class="form-textarea <?php echo isset($errores['notas']) ? 'invalid' : ''; ?>" 
                    placeholder="Alergias, condiciones preexistentes, etc."><?php echo htmlspecialchars($datosPaciente['notas'] ?? ''); ?></textarea>
          <?php if (isset($errores['notas'])): ?>
          <div class="form-error"><?php echo $errores['notas']; ?></div>
          <?php endif; ?>
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