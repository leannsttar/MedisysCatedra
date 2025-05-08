<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$idPaciente = $_GET['id'] ?? null;
if (!$idPaciente) {
    header('Location: pacientes.php');
    exit;
}

// Obtener información del paciente
$sqlPaciente = "SELECT Nombre, Apellido, Fecha_Nacimiento, Sexo, Telefono, Direccion, Contacto_Emergencia, Telefono_Contacto_Emergencia
                FROM Paciente WHERE ID_Paciente = ?";
$paciente = obtenerFila(ejecutarConsulta($sqlPaciente, [$idPaciente]));

if (!$paciente) {
    header('Location: pacientes.php');
    exit;
}

// Obtener citas del paciente
$sqlCitas = "SELECT c.ID_Cita, c.Fecha_Hora, c.Estado_Cita, CONCAT(per.Nombre, ' ', per.Apellido) AS Medico
             FROM Cita c
             INNER JOIN Medico m ON c.ID_Medico = m.ID_Medico
             INNER JOIN Personal per ON m.ID_Medico = per.ID_Personal
             WHERE c.ID_Paciente = ?
             ORDER BY c.Fecha_Hora DESC";
$citas = obtenerFilas(ejecutarConsulta($sqlCitas, [$idPaciente]));

// Obtener visitas médicas del paciente
$sqlVisitas = "SELECT v.ID_Visita, v.Fecha_Visita, CONCAT(per.Nombre, ' ', per.Apellido) AS Medico, v.Diagnostico
               FROM Visita_Medica v
               INNER JOIN Medico m ON v.ID_Medico = m.ID_Medico
               INNER JOIN Personal per ON m.ID_Medico = per.ID_Personal
               WHERE v.ID_Paciente = ?
               ORDER BY v.Fecha_Visita DESC";
$visitas = obtenerFilas(ejecutarConsulta($sqlVisitas, [$idPaciente]));

$tituloPagina = "Detalle del Paciente: " . htmlspecialchars($paciente['Nombre']);
require_once '../includes/header.php';
?>

<div class="container">
  <h1><?php echo htmlspecialchars($paciente['Nombre'] . ' ' . $paciente['Apellido']); ?></h1>
  <p><strong>Fecha de Nacimiento:</strong> 
    <?php echo htmlspecialchars($paciente['Fecha_Nacimiento'] instanceof DateTime ? $paciente['Fecha_Nacimiento']->format('d/m/Y') : $paciente['Fecha_Nacimiento']); ?>
  </p>
  <p><strong>Género:</strong> <?php echo htmlspecialchars($paciente['Sexo']); ?></p>
  <p><strong>Teléfono:</strong> <?php echo htmlspecialchars($paciente['Telefono']); ?></p>
  <p><strong>Dirección:</strong> <?php echo htmlspecialchars($paciente['Direccion']); ?></p>
  <p><strong>Contacto de Emergencia:</strong> <?php echo htmlspecialchars($paciente['Contacto_Emergencia']); ?></p>
  <p><strong>Teléfono de Emergencia:</strong> <?php echo htmlspecialchars($paciente['Telefono_Contacto_Emergencia']); ?></p>

  <h2>Citas</h2>
  <?php if (count($citas) > 0): ?>
    <table class="table">
      <thead>
        <tr>
          <th>Fecha y Hora</th>
          <th>Médico</th>
          <th>Estado</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($citas as $cita): ?>
          <tr>
            <td>
              <?php echo htmlspecialchars($cita['Fecha_Hora'] instanceof DateTime ? $cita['Fecha_Hora']->format('d/m/Y H:i') : $cita['Fecha_Hora']); ?>
            </td>
            <td><?php echo htmlspecialchars($cita['Medico']); ?></td>
            <td><?php echo htmlspecialchars($cita['Estado_Cita']); ?></td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  <?php else: ?>
    <p>No hay citas registradas para este paciente.</p>
  <?php endif; ?>

  <h2>Visitas Médicas</h2>
  <?php if (count($visitas) > 0): ?>
    <table class="table">
      <thead>
        <tr>
          <th>Fecha</th>
          <th>Médico</th>
          <th>Diagnóstico</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($visitas as $visita): ?>
          <tr>
            <td>
              <?php echo htmlspecialchars($visita['Fecha_Visita'] instanceof DateTime ? $visita['Fecha_Visita']->format('d/m/Y H:i') : $visita['Fecha_Visita']); ?>
            </td>
            <td><?php echo htmlspecialchars($visita['Medico']); ?></td>
            <td><?php echo htmlspecialchars($visita['Diagnostico']); ?></td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  <?php else: ?>
    <p>No hay visitas médicas registradas para este paciente.</p>
  <?php endif; ?>
</div>

<?php require_once '../includes/footer.php'; ?>