<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if (!usuarioTienePermiso('gestionar_personal')) {
    header('Location: dashboard.php');
    exit();
}

$tituloPagina = "Personal";
require_once '../includes/header.php';

// Obtener personal con su rol y especialidad (si es médico)
$sql = "SELECT p.ID_Personal, p.Nombre, p.Apellido, p.Telefono, p.Email, r.Nombre_Rol,
        e.Nombre_Especialidad
        FROM Personal p
        INNER JOIN Rol r ON p.ID_Rol = r.ID_Rol
        LEFT JOIN Medico m ON p.ID_Personal = m.ID_Medico
        LEFT JOIN Especialidad e ON m.ID_Especialidad = e.ID_Especialidad
        ORDER BY p.Nombre, p.Apellido";
$personal = obtenerFilas(ejecutarConsulta($sql));
?>

<div class="container">
  <h1>Personal</h1>
  <a href="nuevo_personal.php" class="button">Nuevo Personal</a>
  <div class="table-container">
    <table class="table">
      <thead>
        <tr>
          <th>Nombre</th>
          <th>Apellido</th>
          <th>Rol</th>
          <th>Especialidad</th>
          <th>Teléfono</th>
          <th>Email</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($personal as $p): ?>
        <tr>
          <td><?php echo htmlspecialchars($p['Nombre']); ?></td>
          <td><?php echo htmlspecialchars($p['Apellido']); ?></td>
          <td><?php echo htmlspecialchars($p['Nombre_Rol']); ?></td>
          <td><?php echo htmlspecialchars($p['Nombre_Especialidad'] ?? '-'); ?></td>
          <td><?php echo htmlspecialchars($p['Telefono']); ?></td>
          <td><?php echo htmlspecialchars($p['Email']); ?></td>
          <td>
            <a href="editar_personal.php?id=<?php echo $p['ID_Personal']; ?>" class="button button-small">Editar</a>
            <a href="../logic/eliminar_personal.php?id=<?php echo $p['ID_Personal']; ?>" class="button button-small button-danger" onclick="return confirm('¿Seguro que desea eliminar este personal?');">Eliminar</a>
          </td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>
<?php require_once '../includes/footer.php'; ?>