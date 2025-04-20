<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if (!isset($_GET['paciente_id'])) {
    header("Location: pacientes.php");
    exit();
}

$idPaciente = $_GET['paciente_id'];
$sql = "SELECT * FROM Paciente WHERE id_paciente = ?";
$stmt = ejecutarConsulta($sql, array($idPaciente));
$paciente = obtenerFila($stmt);

if (!$paciente) {
    header("Location: pacientes.php");
    exit();
}

// Recuperar datos del formulario si hay errores
$datosConsulta = $_SESSION['datos_consulta'] ?? array();
$errores = $_SESSION['errores'] ?? array();
unset($_SESSION['datos_consulta']);
unset($_SESSION['errores']);

$tituloPagina = "Nueva Consulta";
require_once '../includes/header.php';
?>

<div class="container">
  <h1>Nueva Consulta para <?php echo htmlspecialchars($paciente['nombre']); ?></h1>
  
  <?php if (isset($errores['general'])): ?>
  <div class="alert alert-danger"><?php echo $errores['general']; ?></div>
  <?php endif; ?>
  
  <form method="POST" action="../logic/crear_consulta.php">
    <input type="hidden" name="id_paciente" value="<?php echo $paciente['id_paciente']; ?>">
    
    <div class="card mb-4">
      <div class="card-header">
        <div class="card-title">Información de la Consulta</div>
        <div class="text-xs text-muted">* Campos obligatorios</div>
      </div>
      <div class="card-content">
        <div class="grid grid-cols-1 grid-md-cols-2 gap-4">
          <div class="form-group">
            <label class="form-label">Médico *</label>
            <input type="text" name="medico" class="form-input <?php echo isset($errores['medico']) ? 'invalid' : ''; ?>" 
                   placeholder="Nombre del médico" required value="<?php echo htmlspecialchars($datosConsulta['medico'] ?? ''); ?>">
            <?php if (isset($errores['medico'])): ?>
            <div class="form-error"><?php echo $errores['medico']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Fecha *</label>
            <input type="date" name="fecha" class="form-input <?php echo isset($errores['fecha']) ? 'invalid' : ''; ?>" 
                   required value="<?php echo htmlspecialchars($datosConsulta['fecha'] ?? date('Y-m-d')); ?>">
            <?php if (isset($errores['fecha'])): ?>
            <div class="form-error"><?php echo $errores['fecha']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Hora *</label>
            <input type="time" name="hora" class="form-input <?php echo isset($errores['hora']) ? 'invalid' : ''; ?>" 
                   required value="<?php echo htmlspecialchars($datosConsulta['hora'] ?? date('H:i')); ?>">
            <?php if (isset($errores['hora'])): ?>
            <div class="form-error"><?php echo $errores['hora']; ?></div>
            <?php endif; ?>
          </div>
        </div>
      </div>
    </div>
    
    <div class="card mb-4">
      <div class="card-header">
        <div class="card-title">Signos Vitales</div>
        <div class="text-xs text-muted">Opcional - Puede completarse después</div>
      </div>
      <div class="card-content">
        <div class="grid grid-cols-1 grid-md-cols-3 gap-4">
          <div class="form-group">
            <label class="form-label">Presión Arterial</label>
            <input type="text" name="tension_arterial" class="form-input" 
                   placeholder="Ej: 120/80" value="<?php echo htmlspecialchars($datosConsulta['tension_arterial'] ?? ''); ?>">
          </div>
          
          <div class="form-group">
            <label class="form-label">Pulso (lpm)</label>
            <input type="number" name="pulso" class="form-input" 
                   placeholder="Ej: 72" value="<?php echo htmlspecialchars($datosConsulta['pulso'] ?? ''); ?>">
          </div>
          
          <div class="form-group">
            <label class="form-label">Temperatura (°C)</label>
            <input type="number" step="0.1" name="temperatura" class="form-input" 
                   placeholder="Ej: 36.5" value="<?php echo htmlspecialchars($datosConsulta['temperatura'] ?? ''); ?>">
          </div>
          
          <div class="form-group">
            <label class="form-label">Saturación O₂ (%)</label>
            <input type="number" name="spo2" class="form-input" 
                   placeholder="Ej: 98" value="<?php echo htmlspecialchars($datosConsulta['spo2'] ?? ''); ?>">
          </div>
          
          <div class="form-group">
            <label class="form-label">Peso (kg)</label>
            <input type="number" step="0.1" name="peso" class="form-input" 
                   placeholder="Ej: 75.5" value="<?php echo htmlspecialchars($datosConsulta['peso'] ?? ''); ?>">
          </div>
          
          <div class="form-group">
            <label class="form-label">Talla (cm)</label>
            <input type="number" name="talla" class="form-input" 
                   placeholder="Ej: 178" value="<?php echo htmlspecialchars($datosConsulta['talla'] ?? ''); ?>">
          </div>
        </div>
      </div>
    </div>
    
    <div class="card">
      <div class="card-header">
        <div class="card-title">Historia Clínica</div>
        <div class="text-xs text-muted">* Motivo de consulta y diagnóstico son obligatorios</div>
      </div>
      <div class="card-content">
        <div class="grid grid-cols-1 gap-4">
          <div class="form-group">
            <label class="form-label">Motivo de Consulta (CX) *</label>
            <textarea name="cx" class="form-textarea <?php echo isset($errores['cx']) ? 'invalid' : ''; ?>" 
                      placeholder="Describa el motivo de la consulta..." required><?php echo htmlspecialchars($datosConsulta['cx'] ?? ''); ?></textarea>
            <?php if (isset($errores['cx'])): ?>
            <div class="form-error"><?php echo $errores['cx']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Examen Físico</label>
            <textarea name="examen_fisico" class="form-textarea" 
                      placeholder="Describa los hallazgos del examen físico..."><?php echo htmlspecialchars($datosConsulta['examen_fisico'] ?? ''); ?></textarea>
          </div>
          
          <div class="form-group">
            <label class="form-label">Diagnóstico (DX) *</label>
            <textarea name="dx" class="form-textarea <?php echo isset($errores['dx']) ? 'invalid' : ''; ?>" 
                      placeholder="Ingrese el diagnóstico..." required><?php echo htmlspecialchars($datosConsulta['dx'] ?? ''); ?></textarea>
            <?php if (isset($errores['dx'])): ?>
            <div class="form-error"><?php echo $errores['dx']; ?></div>
            <?php endif; ?>
          </div>
          
          <div class="form-group">
            <label class="form-label">Plan</label>
            <textarea name="planMedico" class="form-textarea" 
                      placeholder="Describa el plan de tratamiento..."><?php echo htmlspecialchars($datosConsulta['planMedico'] ?? ''); ?></textarea>
          </div>
        </div>
        
        <div class="form-actions">
          <a href="paciente_detalle.php?id=<?php echo $paciente['id_paciente']; ?>" class="button button-secondary">Cancelar</a>
          <button type="submit" class="button">Guardar Consulta</button>
        </div>
      </div>
    </div>
  </form>
</div>

<?php require_once '../includes/footer.php'; ?>