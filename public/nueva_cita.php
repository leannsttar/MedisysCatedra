<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Nueva Cita";
require_once '../includes/header.php';

// Obtener lista de pacientes
$sqlPacientes = "SELECT ID_Paciente, Nombre + ' ' + Apellido AS NombreCompleto FROM Paciente ORDER BY Nombre, Apellido";
$stmtPacientes = ejecutarConsulta($sqlPacientes);
$pacientes = obtenerFilas($stmtPacientes);

// Obtener lista de médicos
$sqlMedicos = "SELECT m.ID_Medico, per.Nombre + ' ' + per.Apellido AS NombreCompleto 
               FROM Medico m
               JOIN Personal per ON m.ID_Medico = per.ID_Personal
               ORDER BY per.Nombre, per.Apellido";
$stmtMedicos = ejecutarConsulta($sqlMedicos);
$medicos = obtenerFilas($stmtMedicos);
?>

<div class="form-container">
  <h1>Programar Nueva Cita</h1>
  <form action="../logic/registrar_cita.php" method="POST">
    <div class="form-group">
      <label for="id_paciente">Paciente</label>
      <select name="id_paciente" id="id_paciente" required>
        <option value="">Seleccione un paciente</option>
        <?php foreach ($pacientes as $paciente): ?>
          <option value="<?php echo $paciente['ID_Paciente']; ?>"><?php echo htmlspecialchars($paciente['NombreCompleto']); ?></option>
        <?php endforeach; ?>
      </select>
    </div>
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
      <label for="fecha_hora">Fecha y Hora</label>
      <input type="datetime-local" name="fecha_hora" id="fecha_hora" required>
    </div>
    <div class="form-group">
      <label for="estado">Estado</label>
      <select name="estado" id="estado" required>
        <option value="Programada">Programada</option>
        <option value="Confirmada">Confirmada</option>
        <option value="Cancelada">Cancelada</option>
        <option value="Realizada">Realizada</option>
        <option value="No Asistio">No Asistió</option>
      </select>
    </div>
    <div class="form-actions">
      <button type="submit" class="button">Guardar Cita</button>
    </div>
  </form>
</div>

<?php require_once '../includes/footer.php'; ?>