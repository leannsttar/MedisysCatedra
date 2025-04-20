<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

// Verificar que se proporcionó un ID de consulta
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    header('Location: consultas.php');
    exit;
}

$idConsulta = $_GET['id'];

// Obtener datos de la consulta
$sql = "SELECT c.id_consulta, c.id_paciente, p.nombre AS nombre_paciente, 
               p.fecha_nacimiento, p.edad, p.sexo, p.telefono,
               c.fecha, c.hora, c.medico_responsable 
        FROM Consulta c 
        INNER JOIN Paciente p ON c.id_paciente = p.id_paciente 
        WHERE c.id_consulta = ?";
$stmt = ejecutarConsulta($sql, array($idConsulta));
$consulta = obtenerFila($stmt);

if (!$consulta) {
    header('Location: consultas.php');
    exit;
}

// Obtener signos vitales
$sqlSignos = "SELECT * FROM SignosVitales WHERE id_consulta = ?";
$stmtSignos = ejecutarConsulta($sqlSignos, array($idConsulta));
$signosVitales = obtenerFila($stmtSignos);

// Obtener historia clínica
$sqlHistoria = "SELECT * FROM HistoriaClinica WHERE id_consulta = ?";
$stmtHistoria = ejecutarConsulta($sqlHistoria, array($idConsulta));
$historiaClinica = obtenerFila($stmtHistoria);

$tituloPagina = "Detalle de Consulta";
require_once '../includes/header.php';

// Formatear la fecha
$fecha = $consulta['fecha']->format('d/m/Y');
$hora = $consulta['hora']->format('H:i');
$idConsultaFormateado = 'C-' . str_pad($consulta['id_consulta'], 3, '0', STR_PAD_LEFT);
$idPacienteFormateado = 'P-' . str_pad($consulta['id_paciente'], 3, '0', STR_PAD_LEFT);
?>

<div class="container">
  <div class="flex items-center justify-between mb-4">
    <h1>Detalle de Consulta <?php echo $idConsultaFormateado; ?></h1>
    <div>
      <a href="consultas.php" class="button button-secondary">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        Volver a Consultas
      </a>
      <a href="editar_consulta.php?id=<?php echo $idConsulta; ?>" class="button">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3Z"/></svg>
        Editar Consulta
      </a>
    </div>
  </div>
  
  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
    <!-- Información de la consulta -->
    <div class="card">
      <div class="card-header">
        <h2>Información de la Consulta</h2>
      </div>
      <div class="card-content">
        <div class="info-group">
          <div class="info-item">
            <span class="info-label">Fecha:</span>
            <span class="info-value"><?php echo $fecha; ?></span>
          </div>
          <div class="info-item">
            <span class="info-label">Hora:</span>
            <span class="info-value"><?php echo $hora; ?></span>
          </div>
          <div class="info-item">
            <span class="info-label">Médico:</span>
            <span class="info-value"><?php echo htmlspecialchars($consulta['medico_responsable']); ?></span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Información del paciente -->
    <div class="card">
      <div class="card-header">
        <h2>Información del Paciente</h2>
      </div>
      <div class="card-content">
        <div class="info-group">
          <div class="info-item">
            <span class="info-label">ID:</span>
            <span class="info-value"><?php echo $idPacienteFormateado; ?></span>
          </div>
          <div class="info-item">
            <span class="info-label">Nombre:</span>
            <span class="info-value"><?php echo htmlspecialchars($consulta['nombre_paciente']); ?></span>
          </div>
          <div class="info-item">
            <span class="info-label">Edad:</span>
            <span class="info-value"><?php echo $consulta['edad']; ?> años</span>
          </div>
          <div class="info-item">
            <span class="info-label">Sexo:</span>
            <span class="info-value">
              <?php 
              $sexo = $consulta['sexo'];
              if ($sexo == 'M') echo 'Masculino';
              elseif ($sexo == 'F') echo 'Femenino';
              else echo 'Otro';
              ?>
            </span>
          </div>
          <div class="info-item">
            <span class="info-label">Teléfono:</span>
            <span class="info-value"><?php echo htmlspecialchars($consulta['telefono']); ?></span>
          </div>
        </div>
        <div class="mt-4">
          <a href="paciente_detalle.php?id=<?php echo $consulta['id_paciente']; ?>" class="button button-secondary">
            Ver Ficha Completa
          </a>
        </div>
      </div>
    </div>
  </div>
  
  <div class="mt-4">
    <!-- Signos Vitales -->
    <div class="card mb-4">
      <div class="card-header">
        <h2>Signos Vitales</h2>
      </div>
      <div class="card-content">
        <?php if ($signosVitales): ?>
        <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
          <div class="info-item">
            <span class="info-label">Peso:</span>
            <span class="info-value"><?php echo $signosVitales['peso']; ?> kg</span>
          </div>
          <div class="info-item">
            <span class="info-label">Talla:</span>
            <span class="info-value"><?php echo $signosVitales['talla']; ?> cm</span>
          </div>
          <div class="info-item">
            <span class="info-label">Temperatura:</span>
            <span class="info-value"><?php echo $signosVitales['temperatura']; ?> °C</span>
          </div>
          <div class="info-item">
            <span class="info-label">SpO2:</span>
            <span class="info-value"><?php echo $signosVitales['spo2']; ?> %</span>
          </div>
          <div class="info-item">
            <span class="info-label">Pulso:</span>
            <span class="info-value"><?php echo $signosVitales['pulso']; ?> bpm</span>
          </div>
          <div class="info-item">
            <span class="info-label">Tensión Arterial:</span>
            <span class="info-value"><?php echo $signosVitales['tension_arterial']; ?> mmHg</span>
          </div>
        </div>
        <?php else: ?>
        <p>No se han registrado signos vitales para esta consulta.</p>
        <?php endif; ?>
      </div>
    </div>
    
    <!-- Historia Clínica -->
    <div class="card">
      <div class="card-header">
        <h2>Historia Clínica</h2>
      </div>
      <div class="card-content">
        <?php if ($historiaClinica): ?>
        <div class="mb-4">
          <h3 class="font-bold mb-2">Cuadro Clínico</h3>
          <div class="bg-gray-50 p-3 rounded">
            <?php echo nl2br(htmlspecialchars($historiaClinica['cx'])); ?>
          </div>
        </div>
        
        <div class="mb-4">
          <h3 class="font-bold mb-2">Examen Físico</h3>
          <div class="bg-gray-50 p-3 rounded">
            <?php echo nl2br(htmlspecialchars($historiaClinica['examen_fisico'])); ?>
          </div>
        </div>
        
        <div class="mb-4">
          <h3 class="font-bold mb-2">Diagnóstico</h3>
          <div class="bg-gray-50 p-3 rounded">
            <?php echo nl2br(htmlspecialchars($historiaClinica['dx'])); ?>
          </div>
        </div>
        
        <div>
          <h3 class="font-bold mb-2">Plan de Tratamiento</h3>
          <div class="bg-gray-50 p-3 rounded">
            <?php echo nl2br(htmlspecialchars($historiaClinica['planMedico'])); ?>
          </div>
        </div>
        <?php else: ?>
        <p>No se ha registrado historia clínica para esta consulta.</p>
        <?php endif; ?>
      </div>
    </div>
  </div>
</div>

<?php require_once '../includes/footer.php'; ?>