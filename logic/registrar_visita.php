<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $idPaciente = $_POST['id_paciente'];
    $idMedico = $_POST['id_medico'];
    $idCita = $_POST['id_cita'] ?? null;
    $fechaVisita = $_POST['fecha_visita'];
    $talla = $_POST['talla'] ?? null;
    $peso = $_POST['peso'] ?? null;
    $tensionArterial = $_POST['tension_arterial'] ?? null;
    $pulso = $_POST['pulso'] ?? null;
    $spo2 = $_POST['spo2'] ?? null;
    $temperatura = $_POST['temperatura'] ?? null;
    $motivoConsulta = $_POST['motivo_consulta'];
    $examenFisico = $_POST['examen_fisico'] ?? null;
    $diagnostico = $_POST['diagnostico'];
    $planTratamiento = $_POST['plan_tratamiento'] ?? null;

    // Validar y formatear la fecha de la visita
    $fechaVisitaFormateada = date('Y-m-d H:i:s', strtotime($fechaVisita));
    if (!$fechaVisita || !$fechaVisitaFormateada) {
        // Si la fecha no es válida, redirigir con un mensaje de error
        $_SESSION['error'] = "La fecha y hora proporcionadas no son válidas.";
        header('Location: ../public/nueva_visita.php');
        exit();
    }

    try {
        $sql = "INSERT INTO Visita_Medica (
                    ID_Paciente, ID_Medico, ID_Cita, Fecha_Visita, Talla, Peso, 
                    Tension_Arterial, Pulso, Spo2, Temperatura, Motivo_Consulta, 
                    Examen_Fisico, Diagnostico, Plan_Tratamiento
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $params = array(
            $idPaciente, $idMedico, $idCita, $fechaVisitaFormateada, $talla, $peso,
            $tensionArterial, $pulso, $spo2, $temperatura, $motivoConsulta,
            $examenFisico, $diagnostico, $planTratamiento
        );
        ejecutarConsulta($sql, $params);

        $_SESSION['mensaje'] = "Visita médica registrada exitosamente.";
        header("Location: ../public/visitas.php");
        exit();
    } catch (Exception $e) {
        $_SESSION['error'] = "Error al registrar la visita médica: " . $e->getMessage();
        header("Location: ../public/nueva_visita.php");
        exit();
    }
} else {
    header("Location: ../public/visitas.php");
    exit();
}
?>