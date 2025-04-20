<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Signos Vitales";
require_once '../includes/header.php';

// Obtener signos vitales recientes
$sql = "SELECT TOP 20 s.*, p.nombre as paciente_nombre, c.fecha, c.hora, c.medico_responsable
        FROM SignosVitales s
        JOIN Consulta c ON s.id_consulta = c.id_consulta
        JOIN Paciente p ON c.id_paciente = p.id_paciente
        ORDER BY c.fecha DESC, c.hora DESC";
$stmt = ejecutarConsulta($sql);
$signosVitales = obtenerFilas($stmt);
?>

<div class="container">
  <div class="flex items-center justify-between mb-4">
    <h1>Registro de Signos Vitales</h1>
  </div>
  
  <div class="card mb-4">
    <div class="card-content">
      <div class="text-sm">
        <p>Los signos vitales pueden registrarse durante la creación de una consulta o posteriormente en esta sección.</p>
      </div>
    </div>
  </div>
  
  <div class="card">
    <div class="card-header">
      <div class="card-title">Últimos Registros</div>
    </div>
    <div class="card-content">
      <div class="table-container">
        <table class="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Paciente</th>
              <th>Fecha</th>
              <th>Médico</th>
              <th>Presión</th>
              <th>Pulso</th>
              <th>Temp.</th>
              <th>SpO₂</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($signosVitales as $signo): 
              $fecha = $signo['fecha']->format('d/m/Y');
              $hora = $signo['hora']->format('H:i');
            ?>
            <tr>
              <td>SV-<?php echo str_pad($signo['id_signos'], 3, '0', STR_PAD_LEFT); ?></td>
              <td><?php echo htmlspecialchars($signo['paciente_nombre']); ?></td>
              <td><?php echo $fecha; ?></td>
              <td><?php echo htmlspecialchars($signo['medico_responsable']); ?></td>
              <td><?php echo htmlspecialchars($signo['tension_arterial'] ?? '-'); ?></td>
              <td><?php echo htmlspecialchars($signo['pulso'] ?? '-'); ?></td>
              <td><?php echo htmlspecialchars($signo['temperatura'] ?? '-'); ?>°C</td>
              <td><?php echo htmlspecialchars($signo['spo2'] ?? '-'); ?>%</td>
              <td>
                <a href="consulta_detalle.php?id=<?php echo $signo['id_consulta']; ?>" class="button button-secondary">Ver Consulta</a>
              </td>
            </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<?php require_once '../includes/footer.php'; ?>