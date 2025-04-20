<?php
require_once '../includes/auth.php';
require_once '../includes/db.php';
requerirLogin();

if (!isset($_GET['id'])) {
    header("Location: pacientes.php");
    exit();
}

$idPaciente = $_GET['id'];
$sql = "SELECT * FROM Paciente WHERE id_paciente = ?";
$stmt = ejecutarConsulta($sql, array($idPaciente));
$paciente = obtenerFila($stmt);

if (!$paciente) {
    header("Location: pacientes.php");
    exit();
}

// Obtener consultas del paciente
$sqlConsultas = "SELECT c.id_consulta, c.fecha, c.hora, c.medico_responsable, 
                s.peso, s.talla, s.temperatura, s.spo2, s.pulso, s.tension_arterial,
                h.cx, h.examen_fisico, h.dx, h.planMedico
                FROM Consulta c
                LEFT JOIN SignosVitales s ON c.id_consulta = s.id_consulta
                LEFT JOIN HistoriaClinica h ON c.id_consulta = h.id_consulta
                WHERE c.id_paciente = ?
                ORDER BY c.fecha DESC, c.hora DESC";
$stmtConsultas = ejecutarConsulta($sqlConsultas, array($idPaciente));
$consultas = obtenerFilas($stmtConsultas);

$tituloPagina = $paciente['nombre'];
require_once '../includes/header.php';
?>

<div class="container">
  <!-- Patient Header -->
  <div class="patient-header">
    <div class="patient-avatar"><?php echo substr($paciente['nombre'], 0, 1); ?></div>
    <div class="patient-info">
      <h1><?php echo htmlspecialchars($paciente['nombre']); ?></h1>
      <div class="patient-meta">
        <div class="patient-meta-item">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
          <?php echo $paciente['edad']; ?> años (<?php echo $paciente['fecha_nacimiento']->format('d/m/Y'); ?>)
        </div>
        <div class="patient-meta-item">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          <?php 
          switch ($paciente['sexo']) {
              case 'M': echo 'Masculino'; break;
              case 'F': echo 'Femenino'; break;
              default: echo 'Otro';
          }
          ?>
        </div>
        <div class="patient-meta-item">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
          <?php echo htmlspecialchars($paciente['telefono']); ?>
        </div>
        <?php if ($paciente['correo']): ?>
        <div class="patient-meta-item">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
          <?php echo htmlspecialchars($paciente['correo']); ?>
        </div>
        <?php endif; ?>
      </div>
    </div>
    <div class="patient-actions">
      <a href="editar-paciente.php?id=<?php echo $paciente['id_paciente']; ?>" class="button button-outline">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
        Editar
      </a>
      <a href="nueva-consulta.php?paciente_id=<?php echo $paciente['id_paciente']; ?>" class="button">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><rect width="8" height="4" x="8" y="2" rx="1" ry="1"/><path d="M12 11h4"/><path d="M12 16h4"/><path d="M8 11h.01"/><path d="M8 16h.01"/></svg>
        Nueva Consulta
      </a>
    </div>
  </div>

  <!-- Patient Information Card -->
  <div class="card">
    <div class="card-header">
      <div class="card-title">Información Personal</div>
    </div>
    <div class="card-content">
      <div class="grid grid-cols-1 grid-md-cols-2">
        <div class="info-group">
          <div class="info-label">Número de Expediente</div>
          <div class="info-value">EXP-<?php echo str_pad($paciente['id_paciente'], 3, '0', STR_PAD_LEFT); ?></div>
        </div>
        <div class="info-group">
          <div class="info-label">Fecha de Nacimiento</div>
          <div class="info-value"><?php echo $paciente['fecha_nacimiento']->format('d/m/Y'); ?></div>
        </div>
        <?php if ($paciente['direccion']): ?>
        <div class="info-group">
          <div class="info-label">Dirección</div>
          <div class="info-value"><?php echo htmlspecialchars($paciente['direccion']); ?></div>
        </div>
        <?php endif; ?>
        <?php if ($paciente['contacto_emergencia']): ?>
        <div class="info-group">
          <div class="info-label">Contacto de Emergencia</div>
          <div class="info-value"><?php echo htmlspecialchars($paciente['contacto_emergencia']); ?></div>
        </div>
        <?php endif; ?>
        <?php if ($paciente['telefono_emergencia']): ?>
        <div class="info-group">
          <div class="info-label">Teléfono de Emergencia</div>
          <div class="info-value"><?php echo htmlspecialchars($paciente['telefono_emergencia']); ?></div>
        </div>
        <?php endif; ?>
        <?php if ($paciente['notas']): ?>
        <div class="info-group">
          <div class="info-label">Notas Adicionales</div>
          <div class="info-value"><?php echo htmlspecialchars($paciente['notas']); ?></div>
        </div>
        <?php endif; ?>
      </div>
    </div>
  </div>

  <!-- Consultas del Paciente -->
  <div class="card">
    <div class="card-header">
      <div class="flex items-center justify-between">
        <div class="card-title">Consultas Médicas</div>
        <a href="nueva-consulta.php?paciente_id=<?php echo $paciente['id_paciente']; ?>" class="button">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14"/><path d="M5 12h14"/></svg>
          Nueva Consulta
        </a>
      </div>
    </div>
    <div class="card-content">
      <?php if (count($consultas) > 0): ?>
        <?php foreach ($consultas as $consulta): 
          $fecha = $consulta['fecha']->format('d/m/Y');
          $hora = $consulta['hora']->format('H:i');
        ?>
        <div class="consultation">
          <div class="consultation-header">
            <div class="consultation-title">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
              Consulta #C-<?php echo str_pad($consulta['id_consulta'], 3, '0', STR_PAD_LEFT); ?>
            </div>
            <div class="consultation-meta">
              <span><?php echo $fecha; ?></span>
              <span><?php echo $hora; ?></span>
              <span><?php echo htmlspecialchars($consulta['medico_responsable']); ?></span>
            </div>
          </div>
          <div class="consultation-content">
            <!-- Signos Vitales -->
            <?php if ($consulta['peso'] || $consulta['talla'] || $consulta['temperatura'] || $consulta['spo2'] || $consulta['pulso'] || $consulta['tension_arterial']): ?>
            <div class="consultation-section">
              <div class="consultation-section-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                Signos Vitales
              </div>
              <div class="grid grid-cols-2 grid-md-cols-3 gap-4">
                <?php if ($consulta['tension_arterial']): ?>
                <div class="vital-sign">
                  <div class="vital-sign-value"><?php echo htmlspecialchars($consulta['tension_arterial']); ?></div>
                  <div class="vital-sign-label">Presión Arterial</div>
                </div>
                <?php endif; ?>
                
                <?php if ($consulta['pulso']): ?>
                <div class="vital-sign">
                  <div class="vital-sign-value"><?php echo htmlspecialchars($consulta['pulso']); ?></div>
                  <div class="vital-sign-label">Pulso (lpm)</div>
                </div>
                <?php endif; ?>
                
                <?php if ($consulta['temperatura']): ?>
                <div class="vital-sign">
                  <div class="vital-sign-value"><?php echo htmlspecialchars($consulta['temperatura']); ?></div>
                  <div class="vital-sign-label">Temperatura (°C)</div>
                </div>
                <?php endif; ?>
                
                <?php if ($consulta['spo2']): ?>
                <div class="vital-sign">
                  <div class="vital-sign-value"><?php echo htmlspecialchars($consulta['spo2']); ?>%</div>
                  <div class="vital-sign-label">Saturación O₂</div>
                </div>
                <?php endif; ?>
                
                <?php if ($consulta['peso']): ?>
                <div class="vital-sign">
                  <div class="vital-sign-value"><?php echo htmlspecialchars($consulta['peso']); ?></div>
                  <div class="vital-sign-label">Peso (kg)</div>
                </div>
                <?php endif; ?>
                
                <?php if ($consulta['talla']): ?>
                <div class="vital-sign">
                  <div class="vital-sign-value"><?php echo htmlspecialchars($consulta['talla']); ?></div>
                  <div class="vital-sign-label">Talla (cm)</div>
                </div>
                <?php endif; ?>
              </div>
            </div>
            <?php endif; ?>
            
            <!-- Historia Clínica -->
            <?php if ($consulta['cx'] || $consulta['examen_fisico'] || $consulta['dx'] || $consulta['planMedico']): ?>
            <div class="consultation-section">
              <div class="consultation-section-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/><line x1="16" x2="8" y1="13" y2="13"/><line x1="16" x2="8" y1="17" y2="17"/><line x1="10" x2="8" y1="9" y2="9"/></svg>
                Historia Clínica
              </div>
              <div class="grid grid-cols-1 gap-4">
                <?php if ($consulta['cx']): ?>
                <div class="info-group">
                  <div class="info-label">Motivo de Consulta (CX)</div>
                  <div class="info-value"><?php echo nl2br(htmlspecialchars($consulta['cx'])); ?></div>
                </div>
                <?php endif; ?>
                
                <?php if ($consulta['examen_fisico']): ?>
                <div class="info-group">
                  <div class="info-label">Examen Físico</div>
                  <div class="info-value"><?php echo nl2br(htmlspecialchars($consulta['examen_fisico'])); ?></div>
                </div>
                <?php endif; ?>
                
                <?php if ($consulta['dx']): ?>
                <div class="info-group">
                  <div class="info-label">Diagnóstico (DX)</div>
                  <div class="info-value"><?php echo nl2br(htmlspecialchars($consulta['dx'])); ?></div>
                </div>
                <?php endif; ?>
                
                <?php if ($consulta['planMedico']): ?>
                <div class="info-group">
                  <div class="info-label">Plan</div>
                  <div class="info-value"><?php echo nl2br(htmlspecialchars($consulta['planMedico'])); ?></div>
                </div>
                <?php endif; ?>
              </div>
            </div>
            <?php endif; ?>
          </div>
          <div class="consultation-actions">
            <a href="editar-consulta.php?id=<?php echo $consulta['id_consulta']; ?>" class="button button-secondary">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
              Editar
            </a>
            <a href="imprimir-consulta.php?id=<?php echo $consulta['id_consulta']; ?>" class="button button-secondary" target="_blank">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" x2="12" y1="15" y2="3"/></svg>
              Imprimir
            </a>
          </div>
        </div>
        <?php endforeach; ?>
      <?php else: ?>
        <div class="text-center text-muted py-8">
          No hay consultas registradas para este paciente.
        </div>
      <?php endif; ?>
    </div>
  </div>
</div>

<?php require_once '../includes/footer.php'; ?>