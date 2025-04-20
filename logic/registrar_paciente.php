<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nombre = trim($_POST['nombre']);
    $fechaNacimiento = trim($_POST['fecha_nacimiento']);
    $sexo = trim($_POST['sexo']);
    $telefono = trim($_POST['telefono']);
    $correo = trim($_POST['correo']);
    $direccion = trim($_POST['direccion']);
    $contactoEmergencia = trim($_POST['contacto_emergencia']);
    $telefonoEmergencia = trim($_POST['telefono_emergencia']);
    $notas = trim($_POST['notas']);
    
    // Validaciones básicas
    $errores = array();
    
    if (empty($nombre)) {
        $errores['nombre'] = "El nombre es obligatorio";
    }
    
    if (empty($fechaNacimiento)) {
        $errores['fecha_nacimiento'] = "La fecha de nacimiento es obligatoria";
    }
    
    if (empty($telefono)) {
        $errores['telefono'] = "El teléfono es obligatorio";
    }
    
    if (count($errores) == 0) {
        $sql = "INSERT INTO Paciente (nombre, fecha_nacimiento, sexo, telefono, correo, direccion, contacto_emergencia, telefono_emergencia, notas)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        $params = array(
            $nombre,
            $fechaNacimiento,
            $sexo,
            $telefono,
            $correo,
            $direccion,
            $contactoEmergencia,
            $telefonoEmergencia,
            $notas
        );
        
        $stmt = ejecutarConsulta($sql, $params);
        
        if ($stmt) {
            $idPaciente = sqlsrv_get_field($stmt, 0);
            header("Location: ../public/paciente_detalle.php?id=$idPaciente");
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