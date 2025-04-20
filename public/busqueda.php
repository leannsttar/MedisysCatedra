<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Búsqueda Avanzada";
require_once '../includes/header.php';

$resultados = [];
$tipoBusqueda = $_GET['tipo'] ?? 'paciente';
$criterio = $_GET['criterio'] ?? 'nombre';
$valor = $_GET['valor'] ?? '';

if (!empty($valor)) {
    switch ($tipoBusqueda) {
        case 'paciente':
            $sql = "SELECT id_paciente, nombre, fecha_nacimiento, telefono 
                    FROM Paciente 
                    WHERE nombre LIKE ? 
                    ORDER BY nombre";
            $params = array("%$valor%");
            break;
            
        case 'consulta':
            $sql = "SELECT c.id_consulta, p.nombre as paciente, c.fecha, c.hora, c.medico_responsable 
                    FROM Consulta c
                    JOIN Paciente p ON c.id_paciente = p.id_paciente
                    WHERE p.nombre LIKE ? OR c.medico_responsable LIKE ?
                    ORDER BY c.fecha DESC";
            $params = array("%$valor%", "%$valor%");
            break;
            
        case 'historia':
            $sql = "SELECT h.id_historia, p.nombre as paciente, c.fecha, h.dx 
                    FROM HistoriaClinica h
                    JOIN Consulta c ON h.id_consulta = c.id_consulta
                    JOIN Paciente p ON c.id_paciente = p.id_paciente
                    WHERE h.dx LIKE ? OR p.nombre LIKE ?
                    ORDER BY c.fecha DESC";
            $params = array("%$valor%", "%$valor%");
            break;
            
        case 'signos':
            $sql = "SELECT s.id_signos, p.nombre as paciente, c.fecha, s.tension_arterial, s.pulso, s.temperatura 
                    FROM SignosVitales s
                    JOIN Consulta c ON s.id_consulta = c.id_consulta
                    JOIN Paciente p ON c.id_paciente = p.id_paciente
                    WHERE p.nombre LIKE ?
                    ORDER BY c.fecha DESC";
            $params = array("%$valor%");
            break;
    }
    
    $stmt = ejecutarConsulta($sql, $params);
    $resultados = obtenerFilas($stmt);
}
?>

<div class="container">
  <h1>Búsqueda y Consulta</h1>
  
  <div class="card">
    <div class="card-header">
      <div class="card-title">Búsqueda Avanzada</div>
    </div>
    <div class="card-content">
      <form method="GET">
        <div class="grid grid-cols-1 grid-md-cols-3 gap-4">
          <div class="form-group">
            <label class="form-label">Tipo de Búsqueda</label>
            <select name="tipo" class="form-select">
              <option value="paciente" <?php echo $tipoBusqueda == 'paciente' ? 'selected' : ''; ?>>Paciente</option>
              <option value="consulta" <?php echo $tipoBusqueda == 'consulta' ? 'selected' : ''; ?>>Consulta</option>
              <option value="historia" <?php echo $tipoBusqueda == 'historia' ? 'selected' : ''; ?>>Historia Clínica</option>
              <option value="signos" <?php echo $tipoBusqueda == 'signos' ? 'selected' : ''; ?>>Signos Vitales</option>
            </select>
          </div>
          
          <div class="form-group">
            <label class="form-label">Criterio</label>
            <select name="criterio" class="form-select">
              <option value="nombre" <?php echo $criterio == 'nombre' ? 'selected' : ''; ?>>Nombre</option>
              <option value="fecha" <?php echo $criterio == 'fecha' ? 'selected' : ''; ?>>Fecha</option>
              <option value="diagnostico" <?php echo $criterio == 'diagnostico' ? 'selected' : ''; ?>>Diagnóstico</option>
            </select>
          </div>
          
          <div class="form-group">
            <label class="form-label">Valor a Buscar</label>
            <input type="text" name="valor" class="form-input" placeholder="Ingrese el valor a buscar..." value="<?php echo htmlspecialchars($valor); ?>">
          </div>
        </div>
        
        <div class="form-actions">
          <button type="submit" class="button">Buscar</button>
        </div>
      </form>
    </div>
  </div>
  
  <?php if (!empty($valor)): ?>
  <div class="card mt-4">
    <div class="card-header">
      <div class="card-title">Resultados de Búsqueda</div>
    </div>
    <div class="card-content">
      <?php if (count($resultados) > 0): ?>
        <div class="table-container">
          <table class="table">
            <thead>
              <tr>
                <th>Tipo</th>
                <th>ID</th>
                <th>Paciente</th>
                <th>Fecha</th>
                <th>Detalles</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <?php foreach ($resultados as $resultado): 
                $fecha = isset($resultado['fecha']) ? date('d/m/Y', strtotime($resultado['fecha'])) : '';
              ?>
              <tr>
                <td><?php echo ucfirst($tipoBusqueda); ?></td>
                <td>
                  <?php 
                  switch ($tipoBusqueda) {
                      case 'paciente': echo 'P-' . str_pad($resultado['id_paciente'], 3, '0', STR_PAD_LEFT); break;
                      case 'consulta': echo 'C-' . str_pad($resultado['id_consulta'], 3, '0', STR_PAD_LEFT); break;
                      case 'historia': echo 'HC-' . str_pad($resultado['id_historia'], 3, '0', STR_PAD_LEFT); break;
                      case 'signos': echo 'SV-' . str_pad($resultado['id_signos'], 3, '0', STR_PAD_LEFT); break;
                  }
                  ?>
                </td>
                <td><?php echo htmlspecialchars($resultado['paciente'] ?? $resultado['nombre']); ?></td>
                <td><?php echo $fecha; ?></td>
                <td>
                  <?php 
                  switch ($tipoBusqueda) {
                      case 'paciente': echo $resultado['telefono']; break;
                      case 'consulta': echo htmlspecialchars($resultado['medico_responsable']); break;
                      case 'historia': echo substr($resultado['dx'], 0, 30) . (strlen($resultado['dx']) > 30 ? '...' : ''); break;
                      case 'signos': echo htmlspecialchars($resultado['tension_arterial'] ?? ''); break;
                  }
                  ?>
                </td>
                <td>
                  <?php 
                  $id = match($tipoBusqueda) {
                      'paciente' => $resultado['id_paciente'],
                      'consulta' => $resultado['id_consulta'],
                      'historia' => $resultado['id_historia'],
                      'signos' => $resultado['id_signos']
                  };
                  
                  $pagina = match($tipoBusqueda) {
                      'paciente' => 'paciente_detalle.php',
                      'consulta' => 'consulta_detalle.php',
                      'historia' => 'consulta_detalle.php',
                      'signos' => 'consulta_detalle.php'
                  };
                  ?>
                  <a href="<?php echo $pagina; ?>?id=<?php echo $id; ?>" class="button button-secondary">Ver Detalles</a>
                </td>
              </tr>
              <?php endforeach; ?>
            </tbody>
          </table>
        </div>
      <?php else: ?>
        <div class="text-center text-muted py-8">
          No se encontraron resultados para "<?php echo htmlspecialchars($valor); ?>"
        </div>
      <?php endif; ?>
    </div>
  </div>
  <?php endif; ?>
</div>

<?php require_once '../includes/footer.php'; ?>