<?php
// Configuración de la base de datos
$servidor = "localhost";
$usuario = "root";
$password = "";
$base_datos = "Restaurante";

// Crear conexión
$conn = new mysqli($servidor, $usuario, $password, $base_datos);

if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// Verificar si el formulario ha sido enviado
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $nombre = trim($_POST["nombre"]);
    $cedula = trim($_POST["cedula"]);
    $correo = trim($_POST["correo"]);
    $direccion = trim($_POST["direccion"]);
    $telefono = trim($_POST["telefono"]);
    $id_rol = trim($_POST["id_rol"]);
    $jornada = trim($_POST["jornada"]);
    $salario = trim($_POST["salario"]);

    if (empty($nombre) || empty($cedula) || empty($correo) || empty($direccion)|| empty($telefono)|| empty($id_rol)|| empty($jornada)|| empty($salario)) {
        die("Error: Todos los campos son obligatorios.");
    }

    // Encriptar la contraseña
   // $password_hash = password_hash($password, PASSWORD_DEFAULT);

    $sql = "INSERT INTO empleados (nombre_empleado, cedula, correo, direccion, telefono, id_rol, jornada, salario) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("ssssssss", $nombre_empleado, $cedula, $correo, $direccion, $telefono, $id_rol, $jornada, $telefono, );
        if ($stmt->execute()) {

            header("Location: ../login.html");
            exit();

        } else {
            echo "Error al registrar usuario.";
        }
        $stmt->close();
    } else {
        echo "Error en la preparación de la consulta.";
    }

    // Cerrar conexión
    $conn->close();
}
?>