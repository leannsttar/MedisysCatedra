<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Programar Cita";
require_once '../includes/header.php';

// Obtener pacientes y médicos
$pacientes = ejecutarConsulta("SELECT ID_Paciente, CONCAT(Nombre, ' ', Apellido) AS NombreCompleto FROM Paciente");
$medicos = ejecutarConsulta("SELECT p.ID_Personal, CONCAT(p.Nombre, ' ', p.Apellido) AS NombreCompleto 
                             FROM Personal p 
                             INNER JOIN Rol r ON p.ID_Rol = r.ID_Rol 
                             WHERE r.Nombre_Rol = 'medico'");

// Procesar formulario para programar cita
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $idPaciente = $_POST['id_paciente'];
    $idMedico = $_POST['id_medico'];
    $fechaHora = $_POST['fecha_hora'];

    $sql = "INSERT INTO Cita (Fecha_Hora, ID_Paciente, ID_Medico) VALUES (?, ?, ?)";
    $stmt = ejecutarConsulta($sql, [$fechaHora, $idPaciente, $idMedico]);
    $mensaje = $stmt ? "Cita programada correctamente" : "Error al programar la cita";
}
?>

<div class="container">
  <h1>Programar Cita</h1>
  <?php if (isset($mensaje)): ?>
    <div class="alert"><?php echo $mensaje; ?></div>
  <?php endif; ?>
  <form method="POST">
    <div class="form-group">
      <label for="id_paciente">Paciente</label>
      <select id="id_paciente" name="id_paciente" class="form-select" required>
        <option value="">Seleccione un paciente</option>
        <?php foreach ($pacientes as $paciente): ?>
          <option value="<?php echo $paciente['ID_Paciente']; ?>"><?php echo $paciente['NombreCompleto']; ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div class="form-group">
      <label for="id_medico">Médico</label>
      <select id="id_medico" name="id_medico" class="form-select" required>
        <option value="">Seleccione un médico</option>
        <?php foreach ($medicos as $medico): ?>
          <option value="<?php echo $medico['ID_Personal']; ?>"><?php echo $medico['NombreCompleto']; ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div class="form-group">
      <label for="fecha_hora">Fecha y Hora</label>
      <input type="datetime-local" id="fecha_hora" name="fecha_hora" class="form-input" required>
    </div>
    <button type="submit" class="button">Programar Cita</button>
  </form>
</div>