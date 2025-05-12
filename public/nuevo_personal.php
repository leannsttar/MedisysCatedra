<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if (!usuarioTienePermiso('gestionar_personal')) {
    header('Location: dashboard.php');
    exit();
}

$tituloPagina = "Nuevo Personal";
require_once '../includes/header.php';

// Obtener roles y especialidades
$roles = obtenerFilas(ejecutarConsulta("SELECT ID_Rol, Nombre_Rol FROM Rol"));
$especialidades = obtenerFilas(ejecutarConsulta("SELECT ID_Especialidad, Nombre_Especialidad FROM Especialidad"));
?>

<div class="container">
  <h1>Registrar Nuevo Personal</h1>
  <form action="../logic/registrar_personal.php" method="POST" class="form">
    <div class="form-group">
      <label>Nombre *</label>
      <input type="text" name="nombre" required>
    </div>
    <div class="form-group">
      <label>Apellido *</label>
      <input type="text" name="apellido" required>
    </div>
    <div class="form-group">
      <label>Teléfono</label>
      <input type="text" name="telefono">
    </div>
    <div class="form-group">
      <label>Email</label>
      <input type="email" name="email">
    </div>
    <div class="form-group">
      <label>Rol *</label>
      <select name="id_rol" id="id_rol" required onchange="mostrarEspecialidad(this.value)">
        <option value="">Seleccione un rol</option>
        <?php foreach ($roles as $rol): ?>
          <option value="<?php echo $rol['ID_Rol']; ?>"><?php echo htmlspecialchars($rol['Nombre_Rol']); ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div class="form-group" id="especialidad-group" style="display:none;">
      <label>Especialidad (solo para médicos)</label>
      <select name="id_especialidad">
        <option value="">Seleccione especialidad</option>
        <?php foreach ($especialidades as $esp): ?>
          <option value="<?php echo $esp['ID_Especialidad']; ?>"><?php echo htmlspecialchars($esp['Nombre_Especialidad']); ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <button type="submit" class="button">Guardar</button>
  </form>
</div>
<script>
function mostrarEspecialidad(rolId) {
  // Ajusta el ID según tu tabla (por ejemplo, 2 = Médico)
  document.getElementById('especialidad-group').style.display = (rolId == 2) ? 'block' : 'none';
}
</script>
<?php require_once '../includes/footer.php'; ?>