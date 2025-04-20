<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $idPaciente = $_POST['id_paciente'];
    $medico = trim($_POST['medico']);
    $fecha = trim($_POST['fecha']);
    $hora = trim($_POST['hora']);
    
    // Signos vitales
    $peso = isset($_POST['peso']) ? trim($_POST['peso']) : null;
    $talla = isset($_POST['talla']) ? trim($_POST['talla']) : null;
    $temperatura = isset($_POST['temperatura']) ? trim($_POST['temperatura']) : null;
    $spo2 = isset($_POST['spo2']) ? trim($_POST['spo2']) : null;
    $pulso = isset($_POST['pulso']) ? trim($_POST['pulso']) : null;
    $tensionArterial = isset($_POST['tension_arterial']) ? trim($_POST['tension_arterial']) : null;
    
    // Historia clínica
    $cx = isset($_POST['cx']) ? trim($_POST['cx']) : null;
    $examenFisico = isset($_POST['examen_fisico']) ? trim($_POST['examen_fisico']) : null;
    $dx = isset($_POST['dx']) ? trim($_POST['dx']) : null;
    $planMedico = isset($_POST['planMedico']) ? trim($_POST['planMedico']) : null;
    
    // Validaciones
    $errores = array();
    
    if (empty($medico)) {
        $errores['medico'] = "El nombre del médico es obligatorio";
    }
    
    if (empty($fecha)) {
        $errores['fecha'] = "La fecha es obligatoria";
    }
    
    if (empty($hora)) {
        $errores['hora'] = "La hora es obligatoria";
    }
    
    if (empty($cx)) {
        $errores['cx'] = "El motivo de consulta es obligatorio";
    }
    
    if (empty($dx)) {
        $errores['dx'] = "El diagnóstico es obligatorio";
    }
    
    if (count($errores) == 0) {
        // Iniciar transacción
        sqlsrv_begin_transaction($conn);
        
        try {
            // Insertar consulta
            $sqlConsulta = "INSERT INTO Consulta (id_paciente, medico_responsable, fecha, hora)
                           VALUES (?, ?, ?, ?)";
            $params = array($idPaciente, $medico, $fecha, $hora);
            $stmtConsulta = ejecutarConsulta($sqlConsulta, $params);
            
            if (!$stmtConsulta) {
                throw new Exception("Error al registrar la consulta");
            }
            
            $idConsulta = sqlsrv_get_field($stmtConsulta, 0);
            
            // Insertar signos vitales si hay datos
            if ($peso || $talla || $temperatura || $spo2 || $pulso || $tensionArterial) {
                $sqlSignos = "INSERT INTO SignosVitales (id_consulta, peso, talla, temperatura, spo2, pulso, tension_arterial)
                              VALUES (?, ?, ?, ?, ?, ?, ?)";
                $paramsSignos = array(
                    $idConsulta,
                    $peso,
                    $talla,
                    $temperatura,
                    $spo2,
                    $pulso,
                    $tensionArterial
                );
                $stmtSignos = ejecutarConsulta($sqlSignos, $paramsSignos);
                
                if (!$stmtSignos) {
                    throw new Exception("Error al registrar los signos vitales");
                }
            }
            
            // Insertar historia clínica
            $sqlHistoria = "INSERT INTO HistoriaClinica (id_consulta, cx, examen_fisico, dx, planMedico)
                            VALUES (?, ?, ?, ?, ?)";
            $paramsHistoria = array(
                $idConsulta,
                $cx,
                $examenFisico,
                $dx,
                $planMedico
            );
            $stmtHistoria = ejecutarConsulta($sqlHistoria, $paramsHistoria);
            
            if (!$stmtHistoria) {
                throw new Exception("Error al registrar la historia clínica");
            }
            
            // Confirmar transacción
            sqlsrv_commit($conn);
            
            header("Location: paciente-detalle.php?id=$idPaciente");
            exit();
        } catch (Exception $e) {
            sqlsrv_rollback($conn);
            $errores['general'] = $e->getMessage();
        }
    }
    
    // Si hay errores, guardar para mostrar en el formulario
    $_SESSION['errores'] = $errores;
    $_SESSION['datos_consulta'] = $_POST;
    header("Location: nueva-consulta.php?paciente_id=$idPaciente");
    exit();
}
?>