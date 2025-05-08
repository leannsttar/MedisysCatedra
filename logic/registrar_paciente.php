<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nombre = trim($_POST['nombre']);
    $apellido = trim($_POST['apellido']);
    $fechaNacimiento = trim($_POST['fecha_nacimiento']);
    $sexo = trim($_POST['sexo']);
    $telefono = trim($_POST['telefono']);
    $direccion = trim($_POST['direccion']);
    $contactoEmergencia = trim($_POST['contacto_emergencia']);
    $telefonoEmergencia = trim($_POST['telefono_emergencia']);

    // Validaciones básicas
    $errores = array();

    if (empty($nombre)) {
        $errores['nombre'] = "El nombre es obligatorio";
    }

    if (empty($apellido)) {
        $errores['apellido'] = "El apellido es obligatorio";
    }

    if (empty($fechaNacimiento)) {
        $errores['fecha_nacimiento'] = "La fecha de nacimiento es obligatoria";
    }

    if (empty($sexo)) {
        $errores['sexo'] = "El género es obligatorio";
    }

    if (count($errores) == 0) {
        $sql = "INSERT INTO Paciente (Nombre, Apellido, Fecha_Nacimiento, Sexo, Telefono, Direccion, Contacto_Emergencia, Telefono_Contacto_Emergencia)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        $params = array(
            $nombre,
            $apellido,
            $fechaNacimiento,
            $sexo,
            $telefono,
            $direccion,
            $contactoEmergencia,
            $telefonoEmergencia
        );

        $stmt = ejecutarConsulta($sql, $params);

        if ($stmt) {
            // Redirigir al detalle del paciente recién creado
            header("Location: ../public/pacientes.php");
            exit();
        } else {
            $errores['general'] = "Error al registrar el paciente: " . print_r(sqlsrv_errors(), true);
        }
    }

    // Si hay errores, los guardamos en sesión para mostrarlos en el formulario
    $_SESSION['errores'] = $errores;
    $_SESSION['datos_paciente'] = $_POST;
    header("Location: ../public/nuevo_paciente.php");
    exit();
}
?>