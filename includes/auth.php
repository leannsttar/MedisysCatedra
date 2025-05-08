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
    $sql = "SELECT ID_Usuario, Username, PasswordHash FROM Usuario WHERE Username = ?";
    $stmt = ejecutarConsulta($sql, array($usuario));
    $row = obtenerFila($stmt);

    if (!$row) {
        die('Usuario no encontrado en la base de datos.');
    }

    echo 'Usuario encontrado: ' . print_r($row, true);

    if (password_verify($password, $row['PasswordHash'])) {
        $_SESSION['usuario_id'] = $row['ID_Usuario'];
        $_SESSION['nombre_usuario'] = $row['Username'];
        return true;
    }

    die('Contraseña incorrecta.');
}
?>