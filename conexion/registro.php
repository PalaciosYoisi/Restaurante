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
    $correo = trim($_POST["correo"]);
    $telefono = trim($_POST["telefono"]);

    if (empty($nombre) || empty($correo) || empty($telefono)) {
        die("Error: Todos los campos son obligatorios.");
    }

    // Encriptar la contraseña
   // $password_hash = password_hash($password, PASSWORD_DEFAULT);

    $sql = "INSERT INTO clientes (nombre_cliente, correo, telefono) VALUES (?, ?, ?)";

    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("sss", $nombre, $correo, $telefono);
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