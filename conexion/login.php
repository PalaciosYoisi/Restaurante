<?php 
#1 paso, establecer conexion con la base de datos
$conexion = mysqli_connect("localhost","root","","Restaurante");
#2 paso, verificar la conexion
if(!$conexion){
    echo "error de conexion".mysqli_connect_error();
    exit();

}
#3 establecer comando sql

$sql = "select nombre_empleado, correo from empleados where nombre_empleado='".$_POST['nombre']."' and correo='".$_POST['correo']."'";


#4 ejecutar el comando
$resultado = mysqli_query($conexion, $sql);
$registro = mysqli_fetch_array($resultado);

if($registro){
    header("HTTP/1.1 302 Moved Temporarily"); 
    header("Location: ../vistas.html");
}else {
    echo 'El correo o clave es incorrecto ';
}


?>