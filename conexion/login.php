<?php
// Configuración de la base de datos
$servidor = "localhost";
$usuario_db = "root";
$password_db = "";
$base_datos = "Parqueadero";

// Crear conexión
$conn = new mysqli($servidor, $usuario_db, $password_db, $base_datos);

// Verificar conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

session_start();

// Verificar si el formulario ha sido enviado
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Recibir y limpiar datos del formulario
    $username = trim($_POST["username"]);
    $password = trim($_POST["password"]);

    // Validar que los campos no estén vacíos
    if (empty($username) || empty($password)) {
        die("Error: Todos los campos son obligatorios.");
    }

    // Buscar usuario en la base de datos
    $sql = "SELECT id_usuario, nombre, username, password, rol FROM usuarios WHERE username = ?";
    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $stmt->store_result();

        // Verificar si existe el usuario
        if ($stmt->num_rows > 0) {
            $stmt->bind_result($id_usuario, $nombre, $username, $password_hash, $rol);
            $stmt->fetch();

            // Verificar la contraseña
            if (password_verify($password, $password_hash)) {
                // Guardar datos en la sesión
                $_SESSION["id_usuario"] = $id_usuario;
                $_SESSION["nombre"] = $nombre;
                $_SESSION["rol"] = $rol;

                // Mostrar mensaje según el rol
                if ($rol == "admin") {
                    echo "<h2>Bienvenido, $nombre. Iniciaste sesión como administrador.</h2>";
                } else {
                    echo "<h2>Bienvenido, $nombre. Iniciaste sesión como usuario.</h2>";
                }
            } else {
                echo "<h3 style='color: red;'>Contraseña incorrecta.</h3>";
            }
        } else {
            echo "<h3 style='color: red;'>Usuario no encontrado.</h3>";
        }
        $stmt->close();
    } else {
        echo "<h3 style='color: red;'>Error en la consulta.</h3>";
    }
}

// Cerrar conexión
$conn->close();
?>