<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

// Verificar que se proporcionó un ID de visita
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    header('Location: visitas.php');
    exit;
}

$idVisita = $_GET['id'];

// Obtener datos de la visita médica
$sql = "SELECT v.ID_Visita, 
               v.Fecha_Visita, 
               CONCAT(p.Nombre, ' ', p.Apellido) AS Paciente, 
               CONCAT(m.Nombre, ' ', m.Apellido) AS Medico, 
               v.Talla, 
               v.Peso, 
               v.Tension_Arterial, 
               v.Pulso, 
               v.Spo2, 
               v.Temperatura, 
               v.Motivo_Consulta, 
               v.Examen_Fisico, 
               v.Diagnostico, 
               v.Plan_Tratamiento
        FROM Visita_Medica v
        INNER JOIN Paciente p ON v.ID_Paciente = p.ID_Paciente
        INNER JOIN Personal m ON v.ID_Medico = m.ID_Personal
        WHERE v.ID_Visita = ?";
$stmt = ejecutarConsulta($sql, [$idVisita]);
$visita = obtenerFila($stmt);

if (!$visita) {
    header('Location: visitas.php');
    exit;
}

$tituloPagina = "Detalle de Visita Médica";
require_once '../includes/header.php';
?>

<div class="container">
  <h1>Detalle de Visita Médica</h1>
  <a href="visitas.php" class="button button-secondary">Volver a Visitas</a>
  
  <div class="card mt-4">
    <div class="card-header">
      <h2>Información General</h2>
    </div>
    <div class="card-content">
      <p><strong>Paciente:</strong> <?php echo htmlspecialchars($visita['Paciente']); ?></p>
      <p><strong>Médico:</strong> <?php echo htmlspecialchars($visita['Medico']); ?></p>
      <p><strong>Fecha de la Visita:</strong> 
      <?php 
          echo htmlspecialchars(
              $visita['Fecha_Visita'] instanceof DateTime 
                  ? $visita['Fecha_Visita']->format('Y-m-d H:i:s') 
                  : $visita['Fecha_Visita']
          ); 
      ?>
      </p>
    </div>
  </div>

  <div class="card mt-4">
    <div class="card-header">
      <h2>Signos Vitales</h2>
    </div>
    <div class="card-content">
      <p><strong>Talla:</strong> <?php echo htmlspecialchars($visita['Talla']); ?> cm</p>
      <p><strong>Peso:</strong> <?php echo htmlspecialchars($visita['Peso']); ?> kg</p>
      <p><strong>Tensión Arterial:</strong> <?php echo htmlspecialchars($visita['Tension_Arterial']); ?></p>
      <p><strong>Pulso:</strong> <?php echo htmlspecialchars($visita['Pulso']); ?> ppm</p>
      <p><strong>Saturación de Oxígeno (SpO2):</strong> <?php echo htmlspecialchars($visita['Spo2']); ?>%</p>
      <p><strong>Temperatura:</strong> <?php echo htmlspecialchars($visita['Temperatura']); ?> °C</p>
    </div>
  </div>

  <div class="card mt-4">
    <div class="card-header">
      <h2>Motivo de Consulta</h2>
    </div>
    <div class="card-content">
      <p><?php echo nl2br(htmlspecialchars($visita['Motivo_Consulta'])); ?></p>
    </div>
  </div>

  <?php if (!empty($visita['Examen_Fisico'])): ?>
  <div class="card mt-4">
    <div class="card-header">
      <h2>Examen Físico</h2>
    </div>
    <div class="card-content">
      <p><?php echo nl2br(htmlspecialchars($visita['Examen_Fisico'])); ?></p>
    </div>
  </div>
  <?php endif; ?>

  <div class="card mt-4">
    <div class="card-header">
      <h2>Diagnóstico</h2>
    </div>
    <div class="card-content">
      <p><?php echo nl2br(htmlspecialchars($visita['Diagnostico'])); ?></p>
    </div>
  </div>

  <?php if (!empty($visita['Plan_Tratamiento'])): ?>
  <div class="card mt-4">
    <div class="card-header">
      <h2>Plan de Tratamiento</h2>
    </div>
    <div class="card-content">
      <p><?php echo nl2br(htmlspecialchars($visita['Plan_Tratamiento'])); ?></p>
    </div>
  </div>
  <?php endif; ?>
</div>

<?php require_once '../includes/footer.php'; ?>