<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Historiales Clínicos";
require_once '../includes/header.php';

// Obtener historiales clínicos recientes
$sql = "SELECT TOP 20 h.*, p.nombre as paciente_nombre, c.fecha, c.hora, c.medico_responsable
        FROM HistoriaClinica h
        JOIN Consulta c ON h.id_consulta = c.id_consulta
        JOIN Paciente p ON c.id_paciente = p.id_paciente
        ORDER BY c.fecha DESC, c.hora DESC";
$stmt = ejecutarConsulta($sql);
$historiales = obtenerFilas($stmt);
?>

<div class="container">
  <div class="flex items-center justify-between mb-4">
    <h1>Historiales Clínicos</h1>
  </div>
  
  <div class="card mb-4">
    <div class="card-content">
      <div class="text-sm">
        <p>La información clínica puede registrarse durante la creación de una consulta o completarse posteriormente.</p>
      </div>
    </div>
  </div>
  
  <div class="card">
    <div class="card-header">
      <div class="card-title">Historias Clínicas Recientes</div>
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
              <th>Diagnóstico</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($historiales as $historial): 
              $fecha = $historial['fecha']->format('d/m/Y');
              $dx = substr($historial['dx'], 0, 50) . (strlen($historial['dx']) > 50 ? '...' : '');
            ?>
            <tr>
              <td>HC-<?php echo str_pad($historial['id_historia'], 3, '0', STR_PAD_LEFT); ?></td>
              <td><?php echo htmlspecialchars($historial['paciente_nombre']); ?></td>
              <td><?php echo $fecha; ?></td>
              <td><?php echo htmlspecialchars($historial['medico_responsable']); ?></td>
              <td><?php echo htmlspecialchars($dx); ?></td>
              <td>
                <a href="consulta-detalle.php?id=<?php echo $historial['id_consulta']; ?>" class="button button-secondary">Ver Detalles</a>
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