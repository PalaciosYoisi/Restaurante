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
    $username = trim($_POST["username"]);
    $password = trim($_POST["password"]);
    $rol = trim($_POST["rol"]); 

    if (empty($nombre) || empty($correo) || empty($username) || empty($password) || empty($rol)) {
        die("Error: Todos los campos son obligatorios.");
    }

    // Encriptar la contraseña
    $password_hash = password_hash($password, PASSWORD_DEFAULT);

    $sql = "INSERT INTO usuarios (nombre, correo, username, password, rol) VALUES (?, ?, ?, ?, ?)";

    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("sssss", $nombre, $correo, $username, $password_hash, $rol);
        if ($stmt->execute()) {

            header("Location: ../login_parqueadero.html");
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