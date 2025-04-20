<?php
require_once '../includes/db.php';
require_once '../includes/auth.php';

if (estaLogueado()) {
    header("Location: dashboard.php");
    exit();
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $usuario = trim($_POST['usuario']);
    $password = trim($_POST['password']);
    
    if (verificarCredenciales($usuario, $password)) {
        header("Location: dashboard.php");
        exit();
    } else {
        $error = "Usuario o contraseña incorrectos";
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Medisys - Iniciar Sesión</title>
  <link rel="stylesheet" href="/medisys/assets/css/styles.css">
</head>
<body>
  <!-- Decorative elements -->
  <div class="decoration decoration-1"></div>
  <div class="decoration decoration-2"></div>

  <div class="login-container">
    <!-- Logo -->
    <div class="logo-container">
      <div class="logo">Medisys</div>
      <div class="logo-subtitle">Sistema de Gestión Médica</div>
    </div>

    <!-- Login Card -->
    <div class="card">
      <div class="card-header">
        <h1 class="card-title">Iniciar Sesión</h1>
      </div>
      <div class="card-content">
        <?php if ($error): ?>
        <div class="alert alert-danger"><?php echo $error; ?></div>
        <?php endif; ?>
        
        <form method="POST" action="">
          <div class="form-group">
            <label for="username" class="form-label">Usuario</label>
            <input type="text" id="username" name="usuario" class="form-input" placeholder="Ingrese su nombre de usuario" required>
            <div class="form-error">Por favor ingrese su nombre de usuario</div>
          </div>

          <div class="form-group">
            <label for="password" class="form-label">Contraseña</label>
            <input type="password" id="password" name="password" class="form-input" placeholder="Ingrese su contraseña" required>
            <div class="form-error">Por favor ingrese su contraseña</div>
          </div>

          <div class="form-actions">
            <button type="submit" id="login-button" class="button">
              <div class="spinner"></div>
              <span>Iniciar Sesión</span>
            </button>
          </div>
        </form>

        <div class="text-center mt-4">
          <a href="#" class="link text-sm" onclick="showForgotPassword(event)">¿Olvidó su contraseña?</a>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <div class="text-center mt-4 text-sm text-muted">
      &copy; <?php echo date('Y'); ?> Medisys. Todos los derechos reservados.
    </div>
  </div>

  <script>
    // Función para manejar el inicio de sesión
    function handleLogin(event) {
      event.preventDefault();
      
      // Obtener los valores del formulario
      const username = document.getElementById('username').value.trim();
      const password = document.getElementById('password').value.trim();
      
      // Validar campos
      let isValid = true;
      
      if (!username) {
        document.getElementById('username').classList.add('invalid');
        isValid = false;
      } else {
        document.getElementById('username').classList.remove('invalid');
      }
      
      if (!password) {
        document.getElementById('password').classList.add('invalid');
        isValid = false;
      } else {
        document.getElementById('password').classList.remove('invalid');
      }
      
      if (!isValid) {
        return;
      }
      
      // Mostrar estado de carga
      const loginButton = document.getElementById('login-button');
      loginButton.classList.add('loading');
      loginButton.disabled = true;
      
      // Enviar el formulario
      event.target.submit();
    }
    
    // Función para mostrar el formulario de recuperación de contraseña
    function showForgotPassword(event) {
      event.preventDefault();
      alert('Funcionalidad de recuperación de contraseña no implementada en esta versión.');
    }
    
    // Configurar el evento de submit del formulario
    document.addEventListener('DOMContentLoaded', function() {
      const loginForm = document.querySelector('form');
      if (loginForm) {
        loginForm.addEventListener('submit', handleLogin);
      }
    });
  </script>
</body>
</html>