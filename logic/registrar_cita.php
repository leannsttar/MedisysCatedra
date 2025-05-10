<?php
require_once '../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $idPaciente = $_POST['id_paciente'];
    $idMedico = $_POST['id_medico'];
    $fechaHora = $_POST['fecha_hora'];

    // Validar y formatear la fecha y hora
    $fechaHoraFormateada = date('Y-m-d H:i:s', strtotime($fechaHora));
    if (!$fechaHoraFormateada) {
        // Si la fecha no es válida, redirigir con un mensaje de error
        $_SESSION['error'] = "La fecha y hora proporcionadas no son válidas.";
        header('Location: ../public/nueva_cita.php');
        exit();
    }

    try {
        // Llamar al procedimiento almacenado
        $sql = "{CALL ProgramarCitaManual(?, ?, ?, ?, ?)}";
        $idCita = null;
        $mensaje = null;

        $params = [
            $idPaciente,
            $idMedico,
            $fechaHoraFormateada,
            &$idCita, // Parámetro de salida para el ID de la cita
            &$mensaje // Parámetro de salida para el mensaje
        ];

        $stmt = ejecutarConsulta($sql, $params);

        if ($stmt && $idCita) {
            // Si la cita se registró correctamente, redirigir a la lista de citas
            $_SESSION['mensaje'] = $mensaje; // Mensaje de éxito
            header('Location: ../public/citas.php');
            exit();
        } else {
            // Si hubo un error, redirigir al formulario con el mensaje de error
            $_SESSION['error'] = $mensaje ?: "Error al registrar la cita.";
            header('Location: ../public/nueva_cita.php');
            exit();
        }
    } catch (Exception $e) {
        // Manejar errores de la consulta SQL
        $_SESSION['error'] = "Error al registrar la cita: " . $e->getMessage();
        header('Location: ../public/nueva_cita.php');
        exit();
    }
}
?>