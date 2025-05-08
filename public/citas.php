<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Citas Médicas";
require_once '../includes/header.php';

// Consulta SQL corregida
$sql = "SELECT c.ID_Cita, 
               c.ID_Paciente, 
               c.ID_Medico, 
               p.Nombre + ' ' + p.Apellido AS Paciente, 
               per.Nombre + ' ' + per.Apellido AS Medico, 
               c.Fecha_Hora, 
               c.Estado_Cita AS Estado
        FROM Cita c
        JOIN Paciente p ON c.ID_Paciente = p.ID_Paciente
        JOIN Medico m ON c.ID_Medico = m.ID_Medico
        JOIN Personal per ON m.ID_Medico = per.ID_Personal
        ORDER BY c.Fecha_Hora DESC";
$stmt = ejecutarConsulta($sql);
$citas = obtenerFilas($stmt);

// Obtener lista de pacientes y médicos para el formulario de edición
$sqlPacientes = "SELECT ID_Paciente, Nombre + ' ' + Apellido AS NombreCompleto FROM Paciente ORDER BY Nombre, Apellido";
$pacientes = obtenerFilas(ejecutarConsulta($sqlPacientes));

$sqlMedicos = "SELECT m.ID_Medico, per.Nombre + ' ' + per.Apellido AS NombreCompleto 
               FROM Medico m
               JOIN Personal per ON m.ID_Medico = per.ID_Personal
               ORDER BY per.Nombre, per.Apellido";
$medicos = obtenerFilas(ejecutarConsulta($sqlMedicos));
?>

<div class="container">
  <h1>Citas Médicas</h1>
  <a href="nueva_cita.php" class="button">Nueva Cita</a>
  <div class="table-container">
    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Paciente</th>
          <th>Médico</th>
          <th>Fecha y Hora</th>
          <th>Estado</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($citas as $cita): ?>
        <tr>
          <td><?php echo $cita['ID_Cita']; ?></td>
          <td><?php echo htmlspecialchars($cita['Paciente']); ?></td>
          <td><?php echo htmlspecialchars($cita['Medico']); ?></td>
          <td><?php echo $cita['Fecha_Hora']->format('d/m/Y H:i'); ?></td>
          <td><?php echo htmlspecialchars($cita['Estado']); ?></td>
          <td>
            <button class="button button-secondary" 
                    onclick="openEditModal(<?php echo htmlspecialchars(json_encode([
                        'ID_Cita' => $cita['ID_Cita'],
                        'ID_Paciente' => $cita['ID_Paciente'] ?? '',
                        'ID_Medico' => $cita['ID_Medico'] ?? '',
                        'Fecha_Hora' => $cita['Fecha_Hora']->format('Y-m-d\TH:i'),
                        'Estado' => $cita['Estado']
                    ])); ?>)">
              Editar
            </button>

          </td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>

<!-- Modal para editar cita -->
<div id="editModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeEditModal()">&times;</span>
    <h2>Editar Cita</h2>
    <form id="editForm" action="../logic/editar_cita.php" method="POST">
      <input type="hidden" name="id_cita" id="id_cita">
      <div class="form-group">
        <label for="id_paciente">Paciente</label>
        <select name="id_paciente" id="id_paciente" required>
          <?php foreach ($pacientes as $paciente): ?>
            <option value="<?php echo $paciente['ID_Paciente']; ?>"><?php echo htmlspecialchars($paciente['NombreCompleto']); ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="form-group">
        <label for="id_medico">Médico</label>
        <select name="id_medico" id="id_medico" required>
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
        <button type="submit" class="button">Guardar Cambios</button>
        <button type="button" class="button button-secondary" onclick="closeEditModal()">Cancelar</button>
      </div>
    </form>
  </div>
</div>

<script>
  function openEditModal(cita) {
    document.getElementById('id_cita').value = cita.ID_Cita;
    document.getElementById('id_paciente').value = cita.ID_Paciente;
    document.getElementById('id_medico').value = cita.ID_Medico;
    document.getElementById('fecha_hora').value = cita.Fecha_Hora.replace(' ', 'T');
    document.getElementById('estado').value = cita.Estado;
    document.getElementById('editModal').style.display = 'block';
  }

  function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
  }
</script>

<style>
  .modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100vw;
    height: 100vh;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
  }

  .modal-content {
    background-color: #fff;
    margin: 10% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 50%;
    border-radius: 8px;
  }

  .close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
  }

  .close:hover,
  .close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
  }
</style>

<?php require_once '../includes/footer.php'; ?>