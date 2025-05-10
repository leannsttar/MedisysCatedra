<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Nueva Visita Médica";
require_once '../includes/header.php';

// Obtener lista de pacientes
$sqlPacientes = "SELECT ID_Paciente, CONCAT(Nombre, ' ', Apellido) AS NombreCompleto FROM Paciente ORDER BY Nombre, Apellido";
$stmtPacientes = ejecutarConsulta($sqlPacientes);
$pacientes = obtenerFilas($stmtPacientes);

// Obtener lista de médicos
$sqlMedicos = "SELECT m.ID_Medico, CONCAT(p.Nombre, ' ', p.Apellido) AS NombreCompleto
               FROM Medico m
               INNER JOIN Personal p ON m.ID_Medico = p.ID_Personal
               ORDER BY p.Nombre, p.Apellido";
$stmtMedicos = ejecutarConsulta($sqlMedicos);
$medicos = obtenerFilas($stmtMedicos);

// Obtener citas programadas del paciente seleccionado (si hay un paciente seleccionado)
$idPacienteSeleccionado = $_GET['id_paciente'] ?? null;
$citas = [];
if ($idPacienteSeleccionado) {
    $sqlCitas = "SELECT c.ID_Cita, c.Fecha_Hora, CONCAT(m.Nombre, ' ', m.Apellido) AS Medico
                 FROM Cita c
                 INNER JOIN Personal m ON c.ID_Medico = m.ID_Personal
                 WHERE c.ID_Paciente = ? AND c.Estado_Cita = 'Programada'
                 ORDER BY c.Fecha_Hora";
    $stmtCitas = ejecutarConsulta($sqlCitas, [$idPacienteSeleccionado]);
    $citas = obtenerFilas($stmtCitas);
}
?>

<div class="container">
  <h1>Registrar Nueva Visita Médica</h1>
  <form action="../logic/registrar_visita.php" method="POST" class="form">
    <div class="grid-container">
      <div class="form-group">
        <label for="id_paciente">Paciente</label>
        <select name="id_paciente" id="id_paciente" required onchange="filtrarCitasPorPaciente(this.value)">
          <option value="">Seleccione un paciente</option>
          <?php foreach ($pacientes as $paciente): ?>
            <option value="<?php echo $paciente['ID_Paciente']; ?>" <?php echo $idPacienteSeleccionado == $paciente['ID_Paciente'] ? 'selected' : ''; ?>>
              <?php echo htmlspecialchars($paciente['NombreCompleto']); ?>
            </option>
          <?php endforeach; ?>
        </select>
      </div>

      <?php if ($idPacienteSeleccionado): ?>
        <div class="form-group">
          <label for="id_cita">Cita Programada</label>
          <select name="id_cita" id="id_cita">
            <option value="">Seleccione una cita (opcional)</option>
            <?php foreach ($citas as $cita): ?>
              <option value="<?php echo $cita['ID_Cita']; ?>">
                <?php 
                  if ($cita['Fecha_Hora'] instanceof DateTime) {
                      echo htmlspecialchars($cita['Fecha_Hora']->format('d/m/Y H:i') . ' - ' . $cita['Medico']);
                  } else {
                      echo htmlspecialchars(date('d/m/Y H:i', strtotime($cita['Fecha_Hora'])) . ' - ' . $cita['Medico']);
                  }
                ?>
              </option>
            <?php endforeach; ?>
          </select>
        </div>
      <?php endif; ?>

      <div class="form-group">
        <label for="id_medico">Médico</label>
        <select name="id_medico" id="id_medico" required>
          <option value="">Seleccione un médico</option>
          <?php foreach ($medicos as $medico): ?>
            <option value="<?php echo $medico['ID_Medico']; ?>"><?php echo htmlspecialchars($medico['NombreCompleto']); ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="form-group">
        <label for="fecha_visita">Fecha de la Visita</label>
        <input type="datetime-local" name="fecha_visita" id="fecha_visita" value="<?php echo date('Y-m-d\TH:i'); ?>" required>
      </div>
      <div class="form-group">
        <label for="talla">Talla (cm)</label>
        <input type="number" step="0.01" name="talla" id="talla" min="0" placeholder="Ejemplo: 170.5">
      </div>
      <div class="form-group">
        <label for="peso">Peso (kg)</label>
        <input type="number" step="0.01" name="peso" id="peso" min="0" placeholder="Ejemplo: 70.5">
      </div>
      <div class="form-group">
        <label for="tension_arterial">Tensión Arterial</label>
        <input type="text" name="tension_arterial" id="tension_arterial" placeholder="Ejemplo: 120/80">
      </div>
      <div class="form-group">
        <label for="pulso">Pulso (ppm)</label>
        <input type="number" name="pulso" id="pulso" min="0" placeholder="Ejemplo: 72">
      </div>
      <div class="form-group">
        <label for="spo2">Saturación de Oxígeno (SpO2 %)</label>
        <input type="number" name="spo2" id="spo2" min="0" max="100" placeholder="Ejemplo: 98">
      </div>
      <div class="form-group">
        <label for="temperatura">Temperatura (°C)</label>
        <input type="number" step="0.01" name="temperatura" id="temperatura" placeholder="Ejemplo: 36.5">
      </div>
      <div class="form-group">
        <label for="motivo_consulta">Motivo de Consulta</label>
        <textarea name="motivo_consulta" id="motivo_consulta" required></textarea>
      </div>
      <div class="form-group">
        <label for="examen_fisico">Examen Físico</label>
        <textarea name="examen_fisico" id="examen_fisico"></textarea>
      </div>
      <div class="form-group">
        <label for="diagnostico">Diagnóstico</label>
        <textarea name="diagnostico" id="diagnostico" required></textarea>
      </div>
      <div class="form-group">
        <label for="plan_tratamiento">Plan de Tratamiento</label>
        <textarea name="plan_tratamiento" id="plan_tratamiento"></textarea>
      </div>
    </div>
    <div class="form-actions">
      <button type="submit" class="button">Guardar Visita</button>
    </div>
  </form>
</div>

<script>
  function filtrarCitasPorPaciente(idPaciente) {
    if (idPaciente) {
      window.location.href = `nueva_visita.php?id_paciente=${idPaciente}`;
    } else {
      window.location.href = `nueva_visita.php`;
    }
  }
</script>

<?php require_once '../includes/footer.php'; ?>