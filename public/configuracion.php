<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

$tituloPagina = "Configuración";
require_once '../includes/header.php';

// Obtener configuración actual
$sql = "SELECT * FROM Usuario WHERE id_usuario = ?";
$stmt = ejecutarConsulta($sql, array($_SESSION['usuario_id']));
$usuario = obtenerFila($stmt);

$mensaje = '';

// Procesar actualización de configuración
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nombreUsuario = trim($_POST['nombre_usuario']);
    $correo = trim($_POST['correo']);
    $passwordActual = trim($_POST['password_actual']);
    $nuevaPassword = trim($_POST['nueva_password']);
    $confirmarPassword = trim($_POST['confirmar_password']);
    
    $errores = [];
    
    // Validar credenciales actuales si se cambia la contraseña
    if (!empty($nuevaPassword)) {
        if (!password_verify($passwordActual, $usuario['contraseña'])) {
            $errores['password_actual'] = "La contraseña actual es incorrecta";
        }
        
        if ($nuevaPassword !== $confirmarPassword) {
            $errores['confirmar_password'] = "Las contraseñas no coinciden";
        }
        
        if (strlen($nuevaPassword) < 8) {
            $errores['nueva_password'] = "La contraseña debe tener al menos 8 caracteres";
        }
    }
    
    if (empty($nombreUsuario)) {
        $errores['nombre_usuario'] = "El nombre de usuario es obligatorio";
    }
    
    if (empty($correo)) {
        $errores['correo'] = "El correo electrónico es obligatorio";
    } elseif (!filter_var($correo, FILTER_VALIDATE_EMAIL)) {
        $errores['correo'] = "El correo electrónico no es válido";
    }
    
    if (count($errores) === 0) {
        // Actualizar usuario
        if (!empty($nuevaPassword)) {
            $sql = "UPDATE Usuario SET nombre_usuario = ?, correo = ?, contraseña = ? WHERE id_usuario = ?";
            $params = array(
                $nombreUsuario,
                $correo,
                password_hash($nuevaPassword, PASSWORD_DEFAULT),
                $_SESSION['usuario_id']
            );
        } else {
            $sql = "UPDATE Usuario SET nombre_usuario = ?, correo = ? WHERE id_usuario = ?";
            $params = array(
                $nombreUsuario,
                $correo,
                $_SESSION['usuario_id']
            );
        }
        
        $stmt = ejecutarConsulta($sql, $params);
        
        if ($stmt) {
            $mensaje = "Configuración actualizada correctamente";
            $_SESSION['nombre_usuario'] = $nombreUsuario;
            
            // Refrescar datos del usuario
            $sql = "SELECT * FROM Usuario WHERE id_usuario = ?";
            $stmt = ejecutarConsulta($sql, array($_SESSION['usuario_id']));
            $usuario = obtenerFila($stmt);
        } else {
            $mensaje = "Error al actualizar la configuración";
        }
    }
}
?>

<div class="container">
  <h1>Configuración del Sistema</h1>
  
  <?php if ($mensaje): ?>
  <div class="alert <?php echo strpos($mensaje, 'Error') !== false ? 'alert-danger' : 'alert-success'; ?>">
    <?php echo $mensaje; ?>
  </div>
  <?php endif; ?>
  
  <div class="card">
    <div class="card-header">
      <div class="card-title">Configuración de Usuario</div>
    </div>
    <div class="card-content">
      <form method="POST">
        <div class="grid grid-cols-1 grid-md-cols-2 gap-4">
          <div class="form-group">
            <label class="form-label">Nombre de Usuario *</label>
            <input type="text" name="nombre_usuario" class="form-input" 
                   value="<?php echo htmlspecialchars($usuario['nombre_usuario']); ?>" required>
          </div>
          
          <div class="form-group">
            <label class="form-label">Correo Electrónico *</label>
            <input type="email" name="correo" class="form-input" 
                   value="<?php echo htmlspecialchars($usuario['correo']); ?>" required>
          </div>
        </div>
        
        <div class="mt-8">
          <h3 class="text-lg font-medium mb-4">Cambiar Contraseña</h3>
          
          <div class="grid grid-cols-1 grid-md-cols-2 gap-4">
            <div class="form-group">
              <label class="form-label">Contraseña Actual</label>
              <input type="password" name="password_actual" class="form-input">
              <?php if (isset($errores['password_actual'])): ?>
              <div class="text-red-500 text-sm mt-1"><?php echo $errores['password_actual']; ?></div>
              <?php endif; ?>
            </div>
            
            <div class="form-group">
              <label class="form-label">Nueva Contraseña</label>
              <input type="password" name="nueva_password" class="form-input">
              <?php if (isset($errores['nueva_password'])): ?>
              <div class="text-red-500 text-sm mt-1"><?php echo $errores['nueva_password']; ?></div>
              <?php endif; ?>
            </div>
            
            <div class="form-group">
              <label class="form-label">Confirmar Contraseña</label>
              <input type="password" name="confirmar_password" class="form-input">
              <?php if (isset($errores['confirmar_password'])): ?>
              <div class="text-red-500 text-sm mt-1"><?php echo $errores['confirmar_password']; ?></div>
              <?php endif; ?>
            </div>
          </div>
        </div>
        
        <div class="form-actions">
          <button type="submit" class="button">Guardar Cambios</button>
        </div>
      </form>
    </div>
  </div>
  
  <div class="card mt-4">
    <div class="card-header">
      <div class="card-title">Configuración del Sistema</div>
    </div>
    <div class="card-content">
      <form>
        <div class="grid grid-cols-1 grid-md-cols-2 gap-4">
          <div class="form-group">
            <label class="form-label">Nombre de la Clínica</label>
            <input type="text" class="form-input" value="Clínica Medisys">
          </div>
          
          <div class="form-group">
            <label class="form-label">Dirección</label>
            <input type="text" class="form-input" placeholder="Ingrese la dirección">
          </div>
          
          <div class="form-group">
            <label class="form-label">Teléfono</label>
            <input type="text" class="form-input" placeholder="Ingrese el teléfono">
          </div>
          
          <div class="form-group">
            <label class="form-label">Correo Electrónico</label>
            <input type="email" class="form-input" placeholder="Ingrese el correo">
          </div>
          
          <div class="form-group">
            <label class="form-label">Zona Horaria</label>
            <select class="form-select">
              <option value="America/Mexico_City">Ciudad de México (GMT-6)</option>
              <option value="America/Bogota">Bogotá (GMT-5)</option>
              <option value="America/Santiago">Santiago (GMT-4)</option>
              <option value="America/Buenos_Aires">Buenos Aires (GMT-3)</option>
            </select>
          </div>
          
          <div class="form-group">
            <label class="form-label">Formato de Fecha</label>
            <select class="form-select">
              <option value="DD/MM/YYYY">DD/MM/YYYY</option>
              <option value="MM/DD/YYYY">MM/DD/YYYY</option>
              <option value="YYYY-MM-DD">YYYY-MM-DD</option>
            </select>
          </div>
        </div>
        
        <div class="form-actions">
          <button type="submit" class="button">Guardar Cambios</button>
        </div>
      </form>
    </div>
  </div>
</div>

<?php require_once '../includes/footer.php'; ?>