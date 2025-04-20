<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Consultas Médicas";
require_once '../includes/header.php';

// Búsqueda de consultas
$busqueda = isset($_GET['busqueda']) ? trim($_GET['busqueda']) : '';
$condicion = '';
$params = array();

if (!empty($busqueda)) {
    $condicion = "WHERE p.nombre LIKE ? OR c.medico_responsable LIKE ? OR CONVERT(VARCHAR, c.fecha, 103) LIKE ?";
    $params = array("%$busqueda%", "%$busqueda%", "%$busqueda%");
}

$sql = "SELECT c.id_consulta, p.nombre, c.fecha, c.hora, c.medico_responsable, h.dx 
        FROM Consulta c 
        INNER JOIN Paciente p ON c.id_paciente = p.id_paciente 
        LEFT JOIN HistoriaClinica h ON c.id_consulta = h.id_consulta 
        $condicion 
        ORDER BY c.fecha DESC, c.hora DESC";

$stmt = ejecutarConsulta($sql, $params);
$consultas = obtenerFilas($stmt);
?>

<div class="container">
  <div class="flex items-center justify-between mb-4">
    <h1>Consultas Médicas</h1>
    <a href="nueva_consulta.php" class="button">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14"/><path d="M5 12h14"/></svg>
      Nueva Consulta
    </a>
  </div>
  
  <form method="GET" class="search-box">
    <input type="text" name="busqueda" class="search-input" placeholder="Buscar consulta por paciente, médico o fecha..." value="<?php echo htmlspecialchars($busqueda); ?>">
    <button type="submit" class="search-button">
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
    </button>
  </form>
  
  <div class="card">
    <div class="card-content">
      <div class="table-container">
        <table class="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Paciente</th>
              <th>Fecha</th>
              <th>Hora</th>
              <th>Médico</th>
              <th>Diagnóstico</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($consultas as $consulta): 
              // Formatear la fecha
              $fecha = $consulta['fecha']->format('d/m/Y');
              $hora = $consulta['hora']->format('H:i');
              $idConsulta = str_pad($consulta['id_consulta'], 3, '0', STR_PAD_LEFT);
            ?>
            <tr>
              <td>C-<?php echo $idConsulta; ?></td>
              <td><?php echo htmlspecialchars($consulta['nombre']); ?></td>
              <td><?php echo $fecha; ?></td>
              <td><?php echo $hora; ?></td>
              <td><?php echo htmlspecialchars($consulta['medico_responsable']); ?></td>
              <td><?php echo !empty($consulta['dx']) ? htmlspecialchars($consulta['dx']) : '-'; ?></td>
              <td>
                <a href="consulta_detalle.php?id=<?php echo $consulta['id_consulta']; ?>" class="button button-secondary">Ver Detalles</a>
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