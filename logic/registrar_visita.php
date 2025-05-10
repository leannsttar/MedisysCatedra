<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $idPaciente = $_POST['id_paciente'];
    $idCita = $_POST['id_cita'] ?? null;
    $idMedico = $_POST['id_medico']; // Capturar el ID del médico desde el formulario
    $motivoConsulta = $_POST['motivo_consulta'];
    $diagnostico = $_POST['diagnostico'];

    // Capturar otros valores opcionales del formulario
    $talla = $_POST['talla'] ?? null;
    $peso = $_POST['peso'] ?? null;
    $tensionArterial = $_POST['tension_arterial'] ?? null;
    $pulso = $_POST['pulso'] ?? null;
    $spo2 = $_POST['spo2'] ?? null;
    $temperatura = $_POST['temperatura'] ?? null;
    $examenFisico = $_POST['examen_fisico'] ?? null;
    $planTratamiento = $_POST['plan_tratamiento'] ?? null;

    // Validaciones básicas
    if (empty($idPaciente) || empty($idMedico) || empty($motivoConsulta) || empty($diagnostico)) {
        $_SESSION['error'] = "El paciente, médico, motivo de consulta y diagnóstico son obligatorios.";
        header('Location: ../public/nueva_visita.php');
        exit();
    }

    try {
        // Llamar al procedimiento almacenado
        $sql = "{CALL RegistrarVisitaCompleta(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        $idVisita = null;
        $mensaje = null;

        $params = [
            $idCita,
            $idPaciente,
            $idMedico,
            $talla,
            $peso,
            $tensionArterial,
            $pulso,
            $spo2,
            $temperatura,
            $motivoConsulta,
            $examenFisico,
            $diagnostico,
            $planTratamiento,
            &$idVisita, // Parámetro de salida para el ID de la visita
            &$mensaje // Parámetro de salida para el mensaje
        ];

        $stmt = ejecutarConsulta($sql, $params);

        if ($stmt && $idVisita) {
            $_SESSION['mensaje'] = $mensaje; // Mensaje de éxito
            header('Location: ../public/visitas.php');
            exit();
        } else {
            $_SESSION['error'] = $mensaje ?: "Error al registrar la visita.";
            header('Location: ../public/nueva_visita.php');
            exit();
        }
    } catch (Exception $e) {
        $_SESSION['error'] = "Error al registrar la visita: " . $e->getMessage();
        header('Location: ../public/nueva_visita.php');
        exit();
    }
} else {
    header("Location: ../public/visitas.php");
    exit();
}
?>