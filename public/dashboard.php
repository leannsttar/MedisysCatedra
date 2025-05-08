<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Panel de Control";
require_once '../includes/header.php';
?>

<div class="container">
  <h1>Panel de Control</h1>
  
  <div class="grid grid-cols-1 grid-md-cols-3 gap-4">
    <div class="stats-card">
      <div class="stats-icon">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
      </div>
      <?php
      $sql = "SELECT COUNT(*) as total FROM Paciente";
      $stmt = ejecutarConsulta($sql);
      $row = obtenerFila($stmt);
      ?>
      <div class="stats-value"><?php echo $row['total']; ?></div>
      <div class="stats-label">Pacientes Registrados</div>
    </div>
    
    <div class="stats-card">
      <div class="stats-icon">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
      </div>
      <?php
      $sql = "SELECT COUNT(*) as total FROM Cita WHERE CONVERT(date, Fecha_Hora) = CONVERT(date, GETDATE())";
      $stmt = ejecutarConsulta($sql);
      $row = obtenerFila($stmt);
      ?>
      <div class="stats-value"><?php echo $row['total']; ?></div>
      <div class="stats-label">Citas Hoy</div>
    </div>
    
    <div class="stats-card">
      <div class="stats-icon">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
      </div>
      <?php
      $sql = "SELECT COUNT(*) as total FROM Visita_Medica";
      $stmt = ejecutarConsulta($sql);
      $row = obtenerFila($stmt);
      ?>
      <div class="stats-value"><?php echo $row['total']; ?></div>
      <div class="stats-label">Visitas Médicas</div>
    </div>
  </div>
  
  <div class="card mt-4">
    <div class="card-header">
      <div class="card-title">Consultas Recientes</div>
    </div>
    <div class="card-content">
      <div class="table-container">
        <table class="table">
          <thead>
            <tr>
              <th>Paciente</th>
              <th>Fecha</th>
              <th>Médico</th>
              <th>Diagnóstico</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <?php
            $sql = "SELECT TOP 5 v.ID_Visita, p.Nombre + ' ' + p.Apellido AS Paciente, v.Fecha_Visita, 
                           per.Nombre + ' ' + per.Apellido AS Medico, v.Diagnostico, p.ID_Paciente
                    FROM Visita_Medica v
                    JOIN Paciente p ON v.ID_Paciente = p.ID_Paciente
                    JOIN Medico m ON v.ID_Medico = m.ID_Medico
                    JOIN Personal per ON m.ID_Medico = per.ID_Personal
                    ORDER BY v.Fecha_Visita DESC";
            $stmt = ejecutarConsulta($sql);
            $consultas = obtenerFilas($stmt);
            
            foreach ($consultas as $consulta):
              $fecha = $consulta['Fecha_Visita']->format('d/m/Y');
              $dx = $consulta['Diagnostico'] ? substr($consulta['Diagnostico'], 0, 30) . (strlen($consulta['Diagnostico']) > 30 ? '...' : '') : 'No registrado';
            ?>
            <tr>
              <td><?php echo htmlspecialchars($consulta['Paciente']); ?></td>
              <td><?php echo $fecha; ?></td>
              <td><?php echo htmlspecialchars($consulta['Medico']); ?></td>
              <td><?php echo htmlspecialchars($dx); ?></td>
              <td>
                <a href="paciente_detalle.php?id=<?php echo $consulta['ID_Paciente']; ?>" class="button button-secondary">Ver Detalles</a>
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