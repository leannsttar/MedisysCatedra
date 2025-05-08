<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $idCita = $_POST['id_cita'];
    $idPaciente = $_POST['id_paciente'];
    $idMedico = $_POST['id_medico'];
    $fechaHora = $_POST['fecha_hora'];
    $estado = $_POST['estado'];

    // Validar y formatear la fecha y hora
    $fechaHoraFormateada = date('Y-m-d H:i:s', strtotime($fechaHora));
    if (!$fechaHoraFormateada) {
        // Si la fecha no es válida, redirigir con un mensaje de error
        $_SESSION['error'] = "La fecha y hora proporcionadas no son válidas.";
        header('Location: ../public/citas.php');
        exit();
    }

    try {
        // Actualizar la cita en la base de datos
        $sql = "UPDATE Cita 
                SET ID_Paciente = ?, ID_Medico = ?, Fecha_Hora = ?, Estado_Cita = ?
                WHERE ID_Cita = ?";
        $params = array($idPaciente, $idMedico, $fechaHoraFormateada, $estado, $idCita);
        $stmt = ejecutarConsulta($sql, $params);

        if ($stmt) {
            // Redirigir con un mensaje de éxito
            $_SESSION['mensaje'] = "Cita actualizada exitosamente.";
            header('Location: ../public/citas.php');
            exit();
        } else {
            throw new Exception("No se pudo actualizar la cita.");
        }
    } catch (Exception $e) {
        // Manejar errores de la consulta SQL
        $_SESSION['error'] = "Error al actualizar la cita: " . $e->getMessage();
        header('Location: ../public/citas.php');
        exit();
    }
} else {
    // Si no es una solicitud POST, redirigir a la lista de citas
    header('Location: ../public/citas.php');
    exit();
}
?>