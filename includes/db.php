<?php
$serverName = "DESKTOP-JMRVJV9";
$connectionOptions = array(
    "Database" => "medisys",
    "Uid" => "",
    "PWD" => ""
);

// Establecer conexión
global $conn;
$conn = sqlsrv_connect($serverName, $connectionOptions);

if (!$conn) {
    die("Error de conexión: " . print_r(sqlsrv_errors(), true));
}

function ejecutarConsulta($sql, $params = array()) {
    global $conn;
    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die('Error en la consulta SQL: ' . print_r(sqlsrv_errors(), true));
    }

    return $stmt;
}

function convertirUtf8($array) {
    foreach ($array as $key => $value) {
        if (is_string($value)) {
            $array[$key] = mb_convert_encoding($value, 'UTF-8', 'Windows-1252');
        }
    }
    return $array;
}

function obtenerFila($stmt) {
    $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
    return $row ? convertirUtf8($row) : null;
}

function obtenerFilas($stmt) {
    $rows = array();
    while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        $rows[] = convertirUtf8($row);
    }
    return $rows;
}

function obtenerUltimoIdInsertado() {
    global $conn; // tu conexión global SQLSRV
    $stmt = sqlsrv_query($conn, "SELECT SCOPE_IDENTITY() AS id");
    if ($stmt && $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        return $row['id'];
    }
    return null;
}
