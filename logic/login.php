<?php
require_once '../includes/db.php';
require_once '../includes/auth.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $usuario = trim($_POST['usuario']);
    $password = trim($_POST['password']);
    
    if (verificarCredenciales($usuario, $password)) {
        header("Location: ../public/dashboard.php");
        exit();
    } else {
        header("Location: ../public/index.php?error=1");
        exit();
    }
}
?>