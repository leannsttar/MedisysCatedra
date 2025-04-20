<?php
session_start();

// Verificar si el usuario está logueado
function estaLogueado() {
    return isset($_SESSION['usuario_id']);
}

// Redirigir si no está logueado
function requerirLogin() {
    if (!estaLogueado()) {
        header("Location: /medisys/public/index.php");
        exit();
    }
}

// Verificar credenciales
function verificarCredenciales($usuario, $password) {
    $sql = "SELECT id_usuario, nombre_usuario, contrasena FROM Usuario WHERE nombre_usuario = ?";
    $stmt = ejecutarConsulta($sql, array($usuario));
    $row = obtenerFila($stmt);
    
    if ($row && password_verify($password, $row['contrasena'])) {
        $_SESSION['usuario_id'] = $row['id_usuario'];
        $_SESSION['nombre_usuario'] = $row['nombre_usuario'];
        return true;
    }
    
    return false;
}
?>