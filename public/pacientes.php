<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Pacientes";
require_once '../includes/header.php';

// Búsqueda de pacientes
$busqueda = isset($_GET['busqueda']) ? trim($_GET['busqueda']) : '';
$sql = "SELECT ID_Paciente, Nombre, Apellido, Telefono, Fecha_Nacimiento 
        FROM Paciente 
        WHERE CONCAT(Nombre, ' ', Apellido) LIKE ? 
        ORDER BY Nombre, Apellido";
$params = array("%$busqueda%");
$stmt = ejecutarConsulta($sql, $params);
$pacientes = obtenerFilas($stmt);
?>

<div class="container">
  <div class="flex items-center justify-between mb-4">
    <h1>Pacientes</h1>
    <a href="nuevo_paciente.php" class="button">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14"/><path d="M5 12h14"/></svg>
      Nuevo Paciente
    </a>
  </div>
  
  <form method="GET" class="search-box">
    <input type="text" name="busqueda" class="search-input" placeholder="Buscar paciente por nombre, ID o teléfono..." value="<?php echo htmlspecialchars($busqueda); ?>">
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
              <th>Nombre</th>
              <th>Edad</th>
              <th>Teléfono</th>
              <th>Última Consulta</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($pacientes as $paciente): 
              // Calcular la edad
              $fechaNacimiento = $paciente['Fecha_Nacimiento'];
              $edad = $fechaNacimiento ? date_diff($fechaNacimiento, date_create('today'))->y : 'N/A';

              // Obtener última consulta
              $sqlConsulta = "SELECT TOP 1 Fecha_Visita 
                              FROM Visita_Medica 
                              WHERE ID_Paciente = ? 
                              ORDER BY Fecha_Visita DESC";
              $stmtConsulta = ejecutarConsulta($sqlConsulta, array($paciente['ID_Paciente']));
              $ultimaConsulta = obtenerFila($stmtConsulta);
              $fechaConsulta = $ultimaConsulta ? $ultimaConsulta['Fecha_Visita']->format('d/m/Y') : 'Nunca';
            ?>
            <tr>
              <td>P-<?php echo str_pad($paciente['ID_Paciente'], 3, '0', STR_PAD_LEFT); ?></td>
              <td><?php echo htmlspecialchars($paciente['Nombre'] . ' ' . $paciente['Apellido']); ?></td>
              <td><?php echo $edad; ?> años</td>
              <td><?php echo htmlspecialchars($paciente['Telefono']); ?></td>
              <td><?php echo $fechaConsulta; ?></td>
              <td>
                <a href="paciente_detalle.php?id=<?php echo $paciente['ID_Paciente']; ?>" class="button button-secondary">Ver Detalles</a>
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