<?php
function calcularEdad($fechaNacimiento) {
    $fecha = new DateTime($fechaNacimiento);
    $hoy = new DateTime();
    $edad = $hoy->diff($fecha);
    return $edad->y;
}

function obtenerIniciales($nombre) {
    $iniciales = '';
    $partes = explode(' ', $nombre);
    
    foreach ($partes as $parte) {
        if (!empty($parte)) {
            $iniciales .= strtoupper(substr($parte, 0, 1));
        }
    }
    
    return substr($iniciales, 0, 2);
}

function sanitizarEntrada($dato) {
    return htmlspecialchars(trim($dato), ENT_QUOTES, 'UTF-8');
}

function mostrarMensaje($tipo, $mensaje) {
    $clases = [
        'exito' => 'alert-success',
        'error' => 'alert-danger',
        'advertencia' => 'alert-warning',
        'info' => 'alert-info'
    ];
    
    if (array_key_exists($tipo, $clases)) {
        return "<div class='alert {$clases[$tipo]}'>{$mensaje}</div>";
    }
    return "<div class='alert'>{$mensaje}</div>";
}
?>