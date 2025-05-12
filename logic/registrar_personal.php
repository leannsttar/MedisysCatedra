<?php

require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if (!usuarioTienePermiso('gestionar_personal')) {
    header('Location: ../public/dashboard.php');
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombre = trim($_POST['nombre']);
    $apellido = trim($_POST['apellido']);
    $telefono = trim($_POST['telefono']);
    $email = trim($_POST['email']);
    $idRol = $_POST['id_rol'];
    $idEspecialidad = $_POST['id_especialidad'] ?? null;

    // Validaciones básicas
    if (empty($nombre) || empty($apellido) || empty($idRol)) {
        header('Location: ../public/nuevo_personal.php');
        exit();
    }

    // Insertar en Personal
    $sql = "INSERT INTO Personal (Nombre, Apellido, Telefono, Email, ID_Rol) VALUES (?, ?, ?, ?, ?)";
    $params = [$nombre, $apellido, $telefono, $email, $idRol];
    $stmt = ejecutarConsulta($sql, $params);

    if (!$stmt) {
        // Mostrar errores de SQL Server
        die(print_r(sqlsrv_errors(), true));
    }

    $idPersonal = obtenerUltimoIdInsertado();
    if (!$idPersonal) {
        die('Error: No se pudo obtener el ID del personal insertado.');
    }

    // Si es médico, insertar en Medico
    if ($idRol == 2 && $idEspecialidad) { // 2 = Médico
        $sqlMedico = "INSERT INTO Medico (ID_Medico, ID_Especialidad) VALUES (?, ?)";
        ejecutarConsulta($sqlMedico, [$idPersonal, $idEspecialidad]);
    }
    header('Location: ../public/personal.php');
    exit();
} else {
    header('Location: ../public/nuevo_personal.php?error=1');
    exit();
}
?>