<?php
require_once '../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $idPaciente = $_POST['id_paciente'];
    $idMedico = $_POST['id_medico'];
    $fechaHora = $_POST['fecha_hora'];
    $estado = $_POST['estado'];

    // Validar y formatear la fecha y hora
    $fechaHoraFormateada = date('Y-m-d H:i:s', strtotime($fechaHora));
    if (!$fechaHoraFormateada) {
        // Si la fecha no es válida, redirigir con un mensaje de error
        $_SESSION['error'] = "La fecha y hora proporcionadas no son válidas.";
        header('Location: ../public/nueva_cita.php');
        exit();
    }

    try {
        $sql = "INSERT INTO Cita (ID_Paciente, ID_Medico, Fecha_Hora, Estado_Cita)
                VALUES (?, ?, ?, ?)";
        $params = array($idPaciente, $idMedico, $fechaHoraFormateada, $estado);
        ejecutarConsulta($sql, $params);

        // Redirigir a la lista de citas con un mensaje de éxito
        $_SESSION['mensaje'] = "Cita registrada exitosamente.";
        header('Location: ../public/citas.php');
        exit();
    } catch (Exception $e) {
        // Manejar errores de la consulta SQL
        $_SESSION['error'] = "Error al registrar la cita: " . $e->getMessage();
        header('Location: ../public/nueva_cita.php');
        exit();
    }
}
?>