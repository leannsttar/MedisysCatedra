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
    $sql = "SELECT u.ID_Usuario, u.Username, u.PasswordHash, r.Nombre_Rol
            FROM Usuario u
            INNER JOIN Personal p ON u.ID_Personal = p.ID_Personal
            INNER JOIN Rol r ON p.ID_Rol = r.ID_Rol
            WHERE u.Username = ?";
    $stmt = ejecutarConsulta($sql, array($usuario));
    $row = obtenerFila($stmt);

    if (!$row) {
        die('Usuario no encontrado en la base de datos.');
    }

    if (password_verify($password, $row['PasswordHash'])) {
        $_SESSION['usuario_id'] = $row['ID_Usuario'];
        $_SESSION['nombre_usuario'] = $row['Username'];
        $_SESSION['rol'] = $row['Nombre_Rol'];
 // <--- Guarda el rol en la sesión
        return true;
    }

    die('Contraseña incorrecta.');
}

function usuarioTienePermiso($permiso) {
    $rol = $_SESSION['rol'];
    $permisos = [
        'Administrador' => ['ver_todo', 'gestionar_personal', 'gestionar_pacientes', 'gestionar_citas', 'gestionar_visitas', 'ver_configuracion'],
        'Médico' => ['gestionar_pacientes', 'gestionar_citas', 'gestionar_visitas'],
        'Recepcionista' => ['gestionar_personal'],
    ];
    return in_array($permiso, $permisos[$rol] ?? []);
}
?>