<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Visitas Médicas";
require_once '../includes/header.php';

$sql = "SELECT v.ID_Visita, 
               CONCAT(p.Nombre, ' ', p.Apellido) AS Paciente, 
               CONCAT(m.Nombre, ' ', m.Apellido) AS Medico, 
               v.Fecha_Visita, 
               v.Diagnostico
        FROM Visita_Medica v
        INNER JOIN Paciente p ON v.ID_Paciente = p.ID_Paciente
        INNER JOIN Personal m ON v.ID_Medico = m.ID_Personal
        ORDER BY v.Fecha_Visita DESC";
$stmt = ejecutarConsulta($sql);
$visitas = obtenerFilas($stmt);
?>

<div class="container">
  <h1>Visitas Médicas</h1>
  <a href="nueva_visita.php" class="button">Nueva Visita</a>
  <div class="table-container">
    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Paciente</th>
          <th>Médico</th>
          <th>Fecha</th>
          <th>Diagnóstico</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($visitas as $visita): ?>
        <tr>
          <td><?php echo $visita['ID_Visita']; ?></td>
          <td><?php echo htmlspecialchars($visita['Paciente']); ?></td>
          <td><?php echo htmlspecialchars($visita['Medico']); ?></td>
          <td>
            <?php 
              // Verificar si Fecha_Visita es un objeto DateTime
              if ($visita['Fecha_Visita'] instanceof DateTime) {
                  echo $visita['Fecha_Visita']->format('d/m/Y H:i');
              } else {
                  echo htmlspecialchars($visita['Fecha_Visita']);
              }
            ?>
          </td>
          <td><?php echo htmlspecialchars(substr($visita['Diagnostico'], 0, 50)); ?></td>
          <td>
            <!-- <a href="editar_visita.php?id=<?php echo $visita['ID_Visita']; ?>" class="button button-secondary">Editar</a>
            <a href="eliminar_visita.php?id=<?php echo $visita['ID_Visita']; ?>" class="button button-danger">Eliminar</a> -->
            <a href="visita_detalle.php?id=<?php echo $visita['ID_Visita']; ?>" class="button button-secondary">Ver Detalles</a>
          </td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>

<?php require_once '../includes/footer.php'; ?>