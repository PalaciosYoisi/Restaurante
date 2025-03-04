-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-03-2025 a las 05:57:26
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `restaurante`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_stock` (IN `id_producto` INT, IN `cantidad_vendida` INT)   BEGIN
    UPDATE menu_productos 
    SET stock = stock - cantidad_vendida
    WHERE id_producto = id_producto AND stock >= cantidad_vendida;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_cliente` (IN `p_nombre_cliente` VARCHAR(100), IN `p_correo` VARCHAR(100), IN `p_telefono` VARCHAR(100))   BEGIN
    INSERT INTO clientes (nombre_cliente, correo, telefono)
    VALUES (p_nombre_cliente, p_correo, p_telefono);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `aplicar_descuento` (IN `p_id_venta` INT)   BEGIN 
DECLARE v_total INT; 
DECLARE v_nuevo_total INT;

-- Obtener el total de la venta
SELECT total_venta INTO v_total FROM ventas WHERE id_venta = p_id_venta;

-- Aplicar descuento según el monto de la venta
SET v_nuevo_total = 
    CASE 
        WHEN v_total >= 50000 THEN v_total * 0.85  -- 15% de descuento
        WHEN v_total >= 30000 THEN v_total * 0.90  -- 10% de descuento
        ELSE v_total                               -- Sin descuento
    END;

-- Actualizar el total de la venta con el descuento aplicado
UPDATE ventas SET total_venta = v_nuevo_total WHERE id_venta = p_id_venta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cambiar_estado_mesa` (IN `id_mesa` INT, IN `nuevo_estado` VARCHAR(100))   BEGIN
    UPDATE mesas 
    SET disponibilidad = nuevo_estado
    WHERE id_mesa = id_mesa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `contar_productos_categoria` (IN `p_id_categoria` INT, OUT `p_total_productos` INT)   BEGIN
    SELECT COUNT(*) INTO p_total_productos
    FROM menu_productos
    WHERE id_categoria = p_id_categoria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_ingresos_fecha` (IN `fecha_inicio` DATE, IN `fecha_fin` DATE, OUT `total_ingresos` INT)   BEGIN
    SELECT SUM(total_venta) INTO total_ingresos
    FROM ventas
    WHERE fecha_venta BETWEEN fecha_inicio AND fecha_fin;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_reserva` (IN `id_cliente` INT, IN `id_mesa` INT, IN `fecha_reserva` DATE, IN `hora_reserva` TIME)   BEGIN
    INSERT INTO reservas (id_cliente, id_mesa, fecha_reserva, hora_reserva)
    VALUES (id_cliente, id_mesa, fecha_reserva, hora_reserva);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_venta` (IN `id_empleado` INT, IN `id_cliente` INT, IN `id_producto` INT, IN `id_mesa` INT, IN `cantidad` INT)   BEGIN
    DECLARE precio_producto INT;
    
    -- Obtener el precio del producto
    SELECT precio INTO precio_producto 
    FROM menu_productos 
    WHERE id_producto = id_producto;
    
    -- Insertar la venta
    INSERT INTO ventas (id_empleado, id_cliente, id_producto, id_mesa, fecha_venta, hora_venta, total_venta)
    VALUES (id_empleado, id_cliente, id_producto, id_mesa, CURDATE(), CURTIME(), cantidad * precio_producto);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias_productos`
--

CREATE TABLE `categorias_productos` (
  `id_categoria` int(11) NOT NULL,
  `nombre_categoria` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias_productos`
--

INSERT INTO `categorias_productos` (`id_categoria`, `nombre_categoria`) VALUES
(1, 'Entradas'),
(2, 'Platos Fuertes'),
(3, 'Postres'),
(4, 'Gaseosas'),
(5, 'Cocteles y Micheladas'),
(6, 'Especialidades'),
(7, 'Jugos Naturales');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombre_cliente` varchar(100) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `telefono` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombre_cliente`, `correo`, `telefono`) VALUES
(1, 'Juan Perez', 'juan@email.com', '3204736278'),
(2, 'Yoisi Palacios', 'yoisi@gmail.com', '3234799112'),
(3, 'Maria Gomez', 'maria@gmail.com', '3245938267'),
(4, 'Carlos Samuel', 'carlos@email.com', '32066666'),
(5, 'Juan de Dios', 'juand@gmail.com', '32477777'),
(6, 'Cangreliano', 'cangreliano@email.com', '35999999'),
(7, 'Manuel Espiritu', 'manuel@hotmail.com', '345688888'),
(8, 'Encarnacion', 'encarnacion@gmail.com', '31000000'),
(9, 'Davila', 'davi@gmail.com', '30999999'),
(10, 'Miguel', 'miguel@gmail.com', '32111111'),
(11, 'Delascar', 'delascar@email.com', '308777777'),
(12, 'Kristian', 'kristian@gmail.com', '312675555'),
(13, 'Amansio', 'amansio@email.com', '3109863552'),
(14, 'Brayan', 'brayan@email.com', '334987229'),
(15, 'Ramon', 'ramon@email', '34599999'),
(16, 'Cornelia', 'cornelia@gmail.com', '34887626'),
(17, 'Emigrenol', 'emigre@hotmail.com', '312000000'),
(18, 'Jhonatan', 'jhon@hotmail.com', '3127635289'),
(19, 'Ruperto Mena', 'ruperto', '376756757'),
(20, 'Yiskar', 'yiskar@email.com', '367585698'),
(21, 'Alirio', 'alirio@gmail.com', '388657456'),
(22, 'Himelda', 'himelda@gmail.com', '37675764'),
(23, 'Carlos Gómez', 'carlos@email.com', '987654321'),
(24, 'Carlos Méndez', 'cmendez@mail.com', '3112233445'),
(25, 'Lucía Fernández', 'luciaf@mail.com', '3005566778'),
(26, 'Andrea Rojas', 'aroja@mail.com', '3209988776'),
(27, 'Javier Soto', 'javiers@mail.com', '3156677889'),
(28, 'Gabriela Torres', 'gabyt@mail.com', '3123456789');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id_empleado` int(11) NOT NULL,
  `nombre_empleado` varchar(100) DEFAULT NULL,
  `cedula` int(11) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `telefono` int(11) DEFAULT NULL,
  `id_rol` int(11) DEFAULT NULL,
  `jornada` varchar(100) DEFAULT NULL,
  `salario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `nombre_empleado`, `cedula`, `correo`, `direccion`, `telefono`, `id_rol`, `jornada`, `salario`) VALUES
(1, 'Yarlenis', 1234567890, 'yarlenis@hotmail.com', 'Calle 123', 324576839, 1, 'Día', 3500000),
(2, 'Maria Moreno', 35851561, 'maria@gmail.com', 'Avenida 456', 320822905, 2, 'Noche', 2000000),
(3, 'Jose Lopez', 34567889, 'jose@gmail.com', 'Barrio Jardín', 123456, 4, 'Día', 1200000),
(4, 'Elsa Palacios', 239748392, 'elsa@gmail.com', 'Barrio La Gloria', 320765345, 5, 'Noche', 900000),
(5, 'Tatiana Serna', 89674567, 'tati@hotmail.com', 'Barrio Samper', 345888889, 3, 'Día', 2000000),
(6, 'Elsa Palacios', 239748392, 'elsa@gmail.com', 'Barrio La Gloria', 320765345, 5, 'Noche', 900000),
(7, 'Yussy Cordoba', 89674567, 'yussy@hotmail.com', 'Barrio Samper', 345888889, 3, 'Día', 2000000),
(8, 'Juanita Moreno', 987663545, 'juanita@gmail.com', 'Carrera 6', 351111119, 7, 'Día', 1800000),
(9, 'Alvaro Rodriguez', 34578219, 'alvaro@email.com', 'Pandeyuca', 34567299, 6, 'Noche', 2800000),
(10, 'Nikol Gomez', 123456780, 'nikol@email.com', 'Pandeyuca', 34500000, 2, 'Dia', 2000000),
(11, 'José Lopez', 23456801, 'jose123@hotmail.com', 'Las Margaritas', 320011229, 3, 'Noche', 2000000),
(12, 'Luisa Cordoba', 23487777, 'luisa@gmail.com', 'Tomas Perez', 321000066, 4, 'Día', 2000000),
(13, 'Fernada Arias', 945687886, 'fernanda@email.com', 'Yesca Grande', 356790000, 3, 'Día', 2000000),
(14, 'Yaneth Rodriguez', 35865345, 'yaneth@hotmail.com', 'Pandeyuca', 321888888, 4, 'Noche', 2000000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu_productos`
--

CREATE TABLE `menu_productos` (
  `id_producto` int(11) NOT NULL,
  `nombre_producto` varchar(100) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `precio` decimal(10,3) DEFAULT NULL,
  `presentacion` varchar(100) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `menu_productos`
--

INSERT INTO `menu_productos` (`id_producto`, `nombre_producto`, `id_categoria`, `precio`, `presentacion`, `stock`) VALUES
(1, 'Chicharrón y Patacones', 1, 15.000, '250g', 40),
(2, 'Cazuela de camarones', 2, 35.000, '400g', 20),
(3, 'Brownie con Helado', 3, 10.000, '100g', 30),
(4, 'Coca-Cola', 4, 3.500, '200ml', 100),
(5, 'Aborrajado de Plátano', 1, 10000.000, 'Plátano maduro relleno de queso y frito', 40),
(6, 'Ceviche de Piangua', 1, 18000.000, 'Porción de piangua marinada con limón y cebolla', 35),
(7, 'Tortilla de Pescado', 1, 15000.000, 'Tortilla con pescado fresco del Pacífico', 30),
(8, 'Sancocho de Pescado', 2, 35000.000, 'Caldo con pescado, plátano, yuca y especias', 25),
(9, 'Arroz Clavao', 2, 40000.000, 'Arroz con coco, camarones y langostinos', 20),
(10, 'Encocado de Pescado', 2, 38000.000, 'Filete de pescado en salsa de coco con arroz', 30),
(11, 'Torta de Borojo', 3, 15000.000, 'Torta hecha con borojo, fruta exótica del Chocó', 25),
(12, 'Cocadas Chocoanas', 3, 12000.000, 'Dulces de coco en porciones individuales', 40),
(13, 'Dulce de Chontaduro', 3, 14000.000, 'Postre tradicional con chontaduro y panela', 35),
(14, 'Kola Román', 4, 7000.000, 'Botella de 500ml de gaseosa colombiana', 50),
(15, 'Viche Curado', 5, 25000.000, 'Licor artesanal del Pacífico con hierbas curativas', 20),
(16, 'Biche con Coco', 5, 27000.000, 'Cóctel de biche con leche de coco', 25),
(17, 'Tapao de Pescado', 6, 45000.000, 'Pescado entero con plátano y yuca en caldo', 15),
(18, 'Arroz Atollado Chocoano', 6, 42000.000, 'Arroz con carne ahumada, longaniza y vegetales', 20),
(19, 'Jugo de Borojó', 7, 12000.000, 'Vaso de 500ml, energizante y afrodisíaco', 40),
(20, 'Jugo de Chontaduro', 7, 10000.000, 'Vaso de 500ml con chontaduro y leche', 45),
(21, 'Jugo de Naidí', 7, 11000.000, 'Vaso de 500ml con pulpa de naidí', 35);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mesas`
--

CREATE TABLE `mesas` (
  `id_mesa` int(11) NOT NULL,
  `capacidad` varchar(100) DEFAULT NULL,
  `disponibilidad` varchar(100) DEFAULT NULL CHECK (`disponibilidad` in ('Disponible','No disponible'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mesas`
--

INSERT INTO `mesas` (`id_mesa`, `capacidad`, `disponibilidad`) VALUES
(1, '5 personas', 'No disponible'),
(2, '2 personas', 'Disponible'),
(3, '1 persona', 'No disponible'),
(4, '4 personas', 'No disponible'),
(5, '10 personas', 'Disponible'),
(6, '3 personas', 'No disponible'),
(7, '2 personas', 'Disponible'),
(8, '4 personas', 'Disponible'),
(9, '6 personas', 'No disponible'),
(10, '8 personas', 'Disponible'),
(11, '10 personas', 'Disponible'),
(12, '2 personas', 'No disponible'),
(13, '4 personas', 'Disponible'),
(14, '6 personas', 'No disponible'),
(15, '8 personas', 'Disponible'),
(16, '10 personas', 'No disponible');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `id_reserva` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_mesa` int(11) DEFAULT NULL,
  `fecha_reserva` date DEFAULT NULL,
  `hora_reserva` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reservas`
--

INSERT INTO `reservas` (`id_reserva`, `id_cliente`, `id_mesa`, `fecha_reserva`, `hora_reserva`) VALUES
(1, 1, 1, '2025-02-25', '15:00:00'),
(2, 2, 3, '2025-02-25', '20:00:00'),
(3, 2, 1, '2025-02-25', '12:30:00'),
(4, 3, 2, '2025-02-25', '19:00:00'),
(5, 5, 3, '2025-02-27', '14:00:00'),
(6, 6, 4, '2025-02-27', '16:30:00'),
(7, 8, 5, '2025-02-28', '20:00:00'),
(8, 9, 6, '2025-02-28', '13:00:00'),
(9, 10, 1, '2025-03-01', '18:30:00'),
(10, 12, 2, '2025-03-01', '17:00:00'),
(11, 13, 3, '2025-03-02', '20:30:00'),
(12, 14, 4, '2025-03-02', '15:00:00'),
(13, 24, 7, '2025-03-04', '12:30:00'),
(14, 25, 8, '2025-03-05', '19:00:00'),
(15, 26, 9, '2025-03-06', '14:15:00'),
(16, 27, 10, '2025-03-07', '18:45:00'),
(17, 28, 11, '2025-03-08', '20:00:00'),
(18, 23, 12, '2025-03-09', '13:00:00'),
(19, 22, 13, '2025-03-10', '17:30:00'),
(20, 21, 14, '2025-03-11', '15:00:00'),
(21, 20, 15, '2025-03-12', '12:45:00'),
(22, 19, 16, '2025-03-13', '19:30:00'),
(23, 20, 2, '2025-03-14', '13:00:00'),
(24, 21, 5, '2025-03-15', '18:45:00'),
(25, 22, 7, '2025-03-16', '14:15:00'),
(26, 23, 9, '2025-03-17', '19:30:00'),
(27, 24, 11, '2025-03-18', '20:15:00'),
(28, 25, 14, '2025-03-19', '12:40:00'),
(29, 26, 15, '2025-03-20', '17:10:00'),
(30, 27, 16, '2025-03-21', '15:30:00'),
(31, 28, 4, '2025-03-22', '13:20:00'),
(32, 23, 6, '2025-03-23', '19:50:00'),
(33, 24, 8, '2025-03-24', '12:10:00'),
(34, 25, 10, '2025-03-25', '18:55:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre_rol`) VALUES
(1, 'Gerente'),
(2, 'Chef'),
(3, 'Cocinero/a'),
(4, 'Mesero/a'),
(5, 'Aseador'),
(6, 'Vigilante'),
(7, 'Recepcionista');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_venta` int(11) NOT NULL,
  `id_empleado` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `id_mesa` int(11) DEFAULT NULL,
  `fecha_venta` date DEFAULT NULL,
  `hora_venta` time DEFAULT NULL,
  `total_venta` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id_venta`, `id_empleado`, `id_cliente`, `id_producto`, `id_mesa`, `fecha_venta`, `hora_venta`, `total_venta`) VALUES
(1, 3, 2, 2, 3, '2025-01-30', '21:11:44', 35000),
(2, 3, 2, 4, 1, '2025-02-25', '12:30:00', 35000),
(3, 12, 3, 6, 2, '2025-02-25', '13:00:00', 38000),
(4, 12, 3, 16, 2, '2025-02-25', '13:00:00', 12000),
(5, 14, 1, 13, 3, '2025-02-25', '14:15:00', 7000),
(6, 14, 1, 10, 3, '2025-02-25', '14:15:00', 15000),
(7, 3, 5, 5, 4, '2025-02-25', '19:45:00', 40000),
(8, 3, 5, 14, 4, '2025-02-25', '19:45:00', 25000),
(9, 12, 3, 11, 5, '2025-02-25', '20:10:00', 12000),
(10, 12, 6, 17, 5, '2025-02-25', '20:10:00', 10000),
(30, 12, 4, 2, 1, '2025-02-25', '12:50:00', 28000),
(31, 12, 3, 16, 1, '2025-02-25', '12:50:00', 12000),
(32, 3, 7, 7, 2, '2025-02-25', '13:30:00', 40000),
(33, 14, 8, 8, 3, '2025-02-25', '14:45:00', 42000),
(34, 14, 6, 17, 3, '2025-02-25', '14:45:00', 10000),
(35, 3, 6, 1, 4, '2025-02-25', '15:00:00', 18000),
(36, 3, 9, 15, 4, '2025-02-25', '15:00:00', 15000),
(37, 12, 10, 5, 5, '2025-02-25', '18:30:00', 40000),
(38, 12, 10, 14, 5, '2025-02-25', '18:30:00', 25000),
(39, 12, 24, 3, 7, '2025-03-04', '13:00:00', 25000),
(40, 12, 25, 7, 8, '2025-03-05', '19:30:00', 37000),
(41, 12, 26, 2, 9, '2025-03-06', '14:45:00', 15000),
(42, 12, 27, 5, 10, '2025-03-07', '19:00:00', 45000),
(43, 14, 28, 1, 11, '2025-03-08', '20:30:00', 32000),
(44, 14, 23, 4, 12, '2025-03-09', '13:20:00', 28000),
(45, 14, 22, 6, 13, '2025-03-10', '17:45:00', 39000),
(46, 12, 21, 8, 14, '2025-03-11', '15:15:00', 41000),
(47, 3, 20, 9, 15, '2025-03-12', '13:00:00', 23000),
(48, 14, 19, 10, 16, '2025-03-13', '19:45:00', 50000),
(49, 12, 18, 3, 5, '2025-03-14', '12:45:00', 28000),
(50, 14, 22, 7, 3, '2025-03-15', '19:15:00', 35000),
(51, 3, 24, 2, 9, '2025-03-16', '14:30:00', 18000),
(52, 12, 19, 5, 6, '2025-03-17', '18:10:00', 45000),
(53, 14, 21, 1, 2, '2025-03-18', '20:00:00', 32000),
(54, 3, 25, 4, 10, '2025-03-19', '13:50:00', 26000),
(55, 12, 26, 6, 11, '2025-03-20', '17:20:00', 39000),
(56, 14, 28, 8, 12, '2025-03-21', '15:40:00', 42000),
(57, 3, 23, 9, 14, '2025-03-22', '12:55:00', 24000),
(58, 12, 20, 10, 16, '2025-03-23', '19:00:00', 50000);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_categorias_cantidad_productos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_categorias_cantidad_productos` (
`nombre_categoria` varchar(100)
,`cantidad_productos` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_clientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_clientes` (
`id_cliente` int(11)
,`nombre_cliente` varchar(100)
,`correo` varchar(100)
,`telefono` varchar(100)
,`compras_realizadas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_clientes_frecuentes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_clientes_frecuentes` (
`id_cliente` int(11)
,`nombre_cliente` varchar(100)
,`compras_realizadas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_dias_mas_reservados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_dias_mas_reservados` (
`fecha_reserva` date
,`total_reservas` bigint(21)
,`total_clientes` bigint(21)
,`total_mesas_utilizadas` bigint(21)
,`total_ventas` bigint(21)
,`ingresos_totales` decimal(32,0)
,`empleados_asignados` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_empleados_alto_salario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_empleados_alto_salario` (
`id_empleado` int(11)
,`nombre_empleado` varchar(100)
,`nombre_rol` varchar(100)
,`salario` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_empleados_por_jornada`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_empleados_por_jornada` (
`nombre_empleado` varchar(100)
,`jornada` varchar(100)
,`nombre_rol` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_empleados_roles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_empleados_roles` (
`id_empleado` int(11)
,`nombre_empleado` varchar(100)
,`nombre_rol` varchar(100)
,`jornada` varchar(100)
,`salario` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_ingresos_diarios`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_ingresos_diarios` (
`fecha_venta` date
,`nombre_empleado` varchar(100)
,`ingresos_totales` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_menu_productos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_menu_productos` (
`id_producto` int(11)
,`nombre_producto` varchar(100)
,`nombre_categoria` varchar(100)
,`precio` decimal(10,3)
,`presentacion` varchar(100)
,`stock` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_mesas_disponibles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_mesas_disponibles` (
`id_mesa` int(11)
,`capacidad` varchar(100)
,`reservas_futuras` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_ocupacion_mesas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_ocupacion_mesas` (
`id_mesa` int(11)
,`capacidad` varchar(100)
,`veces_reservada` bigint(21)
,`nivel_demanda` varchar(13)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_productos_mas_vendidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_productos_mas_vendidos` (
`nombre_producto` varchar(100)
,`veces_vendido` bigint(21)
,`ingresos_totales` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_productos_menos_vendidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_productos_menos_vendidos` (
`id_producto` int(11)
,`nombre_producto` varchar(100)
,`nombre_categoria` varchar(100)
,`precio` decimal(10,3)
,`presentacion` varchar(100)
,`stock` int(11)
,`veces_vendido` bigint(21)
,`ingresos_totales` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_reservas_futuras`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_reservas_futuras` (
`id_reserva` int(11)
,`nombre_cliente` varchar(100)
,`fecha_reserva` date
,`hora_reserva` time
,`id_mesa` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_reservas_hoy`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_reservas_hoy` (
`id_reserva` int(11)
,`nombre_cliente` varchar(100)
,`id_mesa` int(11)
,`fecha_reserva` date
,`hora_reserva` time
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_stock_bajo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_stock_bajo` (
`id_producto` int(11)
,`nombre_producto` varchar(100)
,`nombre_categoria` varchar(100)
,`stock` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_ventas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_ventas` (
`id_venta` int(11)
,`nombre_empleado` varchar(100)
,`nombre_cliente` varchar(100)
,`nombre_producto` varchar(100)
,`id_mesa` int(11)
,`fecha_venta` date
,`hora_venta` time
,`total_venta` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_ventas_clientes_frecuentes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_ventas_clientes_frecuentes` (
`id_cliente` int(11)
,`nombre_cliente` varchar(100)
,`total_reservas` bigint(21)
,`total_compras` bigint(21)
,`interacciones_totales` bigint(22)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_ventas_mensuales`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_ventas_mensuales` (
`mes` varchar(7)
,`ingresos_mensuales` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_ventas_por_empleado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_ventas_por_empleado` (
`nombre_empleado` varchar(100)
,`total_ventas` bigint(21)
,`ingresos_generados` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_categorias_cantidad_productos`
--
DROP TABLE IF EXISTS `vista_categorias_cantidad_productos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_categorias_cantidad_productos`  AS SELECT `c`.`nombre_categoria` AS `nombre_categoria`, count(`p`.`id_producto`) AS `cantidad_productos` FROM (`categorias_productos` `c` left join `menu_productos` `p` on(`c`.`id_categoria` = `p`.`id_categoria`)) GROUP BY `c`.`nombre_categoria` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_clientes`
--
DROP TABLE IF EXISTS `vista_clientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_clientes`  AS SELECT `c`.`id_cliente` AS `id_cliente`, `c`.`nombre_cliente` AS `nombre_cliente`, `c`.`correo` AS `correo`, `c`.`telefono` AS `telefono`, count(`v`.`id_venta`) AS `compras_realizadas` FROM (`clientes` `c` left join `ventas` `v` on(`c`.`id_cliente` = `v`.`id_cliente`)) GROUP BY `c`.`id_cliente`, `c`.`nombre_cliente`, `c`.`correo`, `c`.`telefono` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_clientes_frecuentes`
--
DROP TABLE IF EXISTS `vista_clientes_frecuentes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_clientes_frecuentes`  AS SELECT `c`.`id_cliente` AS `id_cliente`, `c`.`nombre_cliente` AS `nombre_cliente`, count(`v`.`id_venta`) AS `compras_realizadas` FROM (`ventas` `v` join `clientes` `c` on(`v`.`id_cliente` = `c`.`id_cliente`)) GROUP BY `c`.`id_cliente`, `c`.`nombre_cliente` HAVING count(`v`.`id_venta`) > 3 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_dias_mas_reservados`
--
DROP TABLE IF EXISTS `vista_dias_mas_reservados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_dias_mas_reservados`  AS SELECT `r`.`fecha_reserva` AS `fecha_reserva`, count(`r`.`id_reserva`) AS `total_reservas`, count(distinct `r`.`id_cliente`) AS `total_clientes`, count(distinct `r`.`id_mesa`) AS `total_mesas_utilizadas`, count(distinct `v`.`id_venta`) AS `total_ventas`, sum(`v`.`total_venta`) AS `ingresos_totales`, count(distinct `e`.`id_empleado`) AS `empleados_asignados` FROM ((((`reservas` `r` left join `clientes` `c` on(`r`.`id_cliente` = `c`.`id_cliente`)) left join `ventas` `v` on(`r`.`id_cliente` = `v`.`id_cliente` and `r`.`fecha_reserva` = `v`.`fecha_venta`)) left join `mesas` `m` on(`r`.`id_mesa` = `m`.`id_mesa`)) left join `empleados` `e` on(`v`.`id_empleado` = `e`.`id_empleado`)) WHERE `r`.`fecha_reserva` >= curdate() - interval 1 month GROUP BY `r`.`fecha_reserva` ORDER BY count(`r`.`id_reserva`) DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_empleados_alto_salario`
--
DROP TABLE IF EXISTS `vista_empleados_alto_salario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_empleados_alto_salario`  AS SELECT `e`.`id_empleado` AS `id_empleado`, `e`.`nombre_empleado` AS `nombre_empleado`, `r`.`nombre_rol` AS `nombre_rol`, `e`.`salario` AS `salario` FROM (`empleados` `e` join `roles` `r` on(`e`.`id_rol` = `r`.`id_rol`)) WHERE `e`.`salario` > 1500000 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_empleados_por_jornada`
--
DROP TABLE IF EXISTS `vista_empleados_por_jornada`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_empleados_por_jornada`  AS SELECT `e`.`nombre_empleado` AS `nombre_empleado`, `e`.`jornada` AS `jornada`, `r`.`nombre_rol` AS `nombre_rol` FROM (`empleados` `e` join `roles` `r` on(`e`.`id_rol` = `r`.`id_rol`)) ORDER BY `e`.`jornada` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_empleados_roles`
--
DROP TABLE IF EXISTS `vista_empleados_roles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_empleados_roles`  AS SELECT `e`.`id_empleado` AS `id_empleado`, `e`.`nombre_empleado` AS `nombre_empleado`, `r`.`nombre_rol` AS `nombre_rol`, `e`.`jornada` AS `jornada`, `e`.`salario` AS `salario` FROM (`empleados` `e` join `roles` `r` on(`e`.`id_rol` = `r`.`id_rol`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_ingresos_diarios`
--
DROP TABLE IF EXISTS `vista_ingresos_diarios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_ingresos_diarios`  AS SELECT `v`.`fecha_venta` AS `fecha_venta`, `e`.`nombre_empleado` AS `nombre_empleado`, sum(`v`.`total_venta`) AS `ingresos_totales` FROM (`ventas` `v` join `empleados` `e` on(`v`.`id_empleado` = `e`.`id_empleado`)) GROUP BY `v`.`fecha_venta`, `e`.`nombre_empleado` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_menu_productos`
--
DROP TABLE IF EXISTS `vista_menu_productos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_menu_productos`  AS SELECT `p`.`id_producto` AS `id_producto`, `p`.`nombre_producto` AS `nombre_producto`, `c`.`nombre_categoria` AS `nombre_categoria`, `p`.`precio` AS `precio`, `p`.`presentacion` AS `presentacion`, `p`.`stock` AS `stock` FROM (`menu_productos` `p` join `categorias_productos` `c` on(`p`.`id_categoria` = `c`.`id_categoria`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_mesas_disponibles`
--
DROP TABLE IF EXISTS `vista_mesas_disponibles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_mesas_disponibles`  AS SELECT `m`.`id_mesa` AS `id_mesa`, `m`.`capacidad` AS `capacidad`, count(`r`.`id_reserva`) AS `reservas_futuras` FROM (`mesas` `m` left join `reservas` `r` on(`m`.`id_mesa` = `r`.`id_mesa` and `r`.`fecha_reserva` > curdate())) WHERE `m`.`disponibilidad` = 'Disponible' GROUP BY `m`.`id_mesa`, `m`.`capacidad` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_ocupacion_mesas`
--
DROP TABLE IF EXISTS `vista_ocupacion_mesas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_ocupacion_mesas`  AS SELECT `m`.`id_mesa` AS `id_mesa`, `m`.`capacidad` AS `capacidad`, count(`r`.`id_reserva`) AS `veces_reservada`, CASE WHEN count(`r`.`id_reserva`) > 20 THEN 'Alta demanda' WHEN count(`r`.`id_reserva`) between 10 and 20 THEN 'Demanda media' ELSE 'Baja demanda' END AS `nivel_demanda` FROM (`mesas` `m` left join `reservas` `r` on(`m`.`id_mesa` = `r`.`id_mesa`)) GROUP BY `m`.`id_mesa`, `m`.`capacidad` ORDER BY count(`r`.`id_reserva`) DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_productos_mas_vendidos`
--
DROP TABLE IF EXISTS `vista_productos_mas_vendidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_productos_mas_vendidos`  AS SELECT `p`.`nombre_producto` AS `nombre_producto`, count(`v`.`id_venta`) AS `veces_vendido`, sum(`v`.`total_venta`) AS `ingresos_totales` FROM (`ventas` `v` join `menu_productos` `p` on(`v`.`id_producto` = `p`.`id_producto`)) GROUP BY `p`.`nombre_producto` ORDER BY count(`v`.`id_venta`) DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_productos_menos_vendidos`
--
DROP TABLE IF EXISTS `vista_productos_menos_vendidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_productos_menos_vendidos`  AS SELECT `p`.`id_producto` AS `id_producto`, `p`.`nombre_producto` AS `nombre_producto`, `c`.`nombre_categoria` AS `nombre_categoria`, `p`.`precio` AS `precio`, `p`.`presentacion` AS `presentacion`, `p`.`stock` AS `stock`, count(`v`.`id_venta`) AS `veces_vendido`, coalesce(sum(`v`.`total_venta`),0) AS `ingresos_totales` FROM ((`menu_productos` `p` left join `ventas` `v` on(`p`.`id_producto` = `v`.`id_producto` and `v`.`fecha_venta` >= curdate() - interval 1 month)) left join `categorias_productos` `c` on(`p`.`id_categoria` = `c`.`id_categoria`)) GROUP BY `p`.`id_producto`, `p`.`nombre_producto`, `c`.`nombre_categoria`, `p`.`precio`, `p`.`presentacion`, `p`.`stock` ORDER BY count(`v`.`id_venta`) ASC LIMIT 0, 10 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_reservas_futuras`
--
DROP TABLE IF EXISTS `vista_reservas_futuras`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_reservas_futuras`  AS SELECT `r`.`id_reserva` AS `id_reserva`, `c`.`nombre_cliente` AS `nombre_cliente`, `r`.`fecha_reserva` AS `fecha_reserva`, `r`.`hora_reserva` AS `hora_reserva`, `m`.`id_mesa` AS `id_mesa` FROM ((`reservas` `r` join `clientes` `c` on(`r`.`id_cliente` = `c`.`id_cliente`)) join `mesas` `m` on(`r`.`id_mesa` = `m`.`id_mesa`)) WHERE `r`.`fecha_reserva` > curdate() ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_reservas_hoy`
--
DROP TABLE IF EXISTS `vista_reservas_hoy`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_reservas_hoy`  AS SELECT `r`.`id_reserva` AS `id_reserva`, `c`.`nombre_cliente` AS `nombre_cliente`, `m`.`id_mesa` AS `id_mesa`, `r`.`fecha_reserva` AS `fecha_reserva`, `r`.`hora_reserva` AS `hora_reserva` FROM ((`reservas` `r` join `clientes` `c` on(`r`.`id_cliente` = `c`.`id_cliente`)) join `mesas` `m` on(`r`.`id_mesa` = `m`.`id_mesa`)) WHERE `r`.`fecha_reserva` = '2025-02-25' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_stock_bajo`
--
DROP TABLE IF EXISTS `vista_stock_bajo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_stock_bajo`  AS SELECT `p`.`id_producto` AS `id_producto`, `p`.`nombre_producto` AS `nombre_producto`, `c`.`nombre_categoria` AS `nombre_categoria`, `p`.`stock` AS `stock` FROM (`menu_productos` `p` join `categorias_productos` `c` on(`p`.`id_categoria` = `c`.`id_categoria`)) WHERE `p`.`stock` < 10 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_ventas`
--
DROP TABLE IF EXISTS `vista_ventas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_ventas`  AS SELECT `v`.`id_venta` AS `id_venta`, `e`.`nombre_empleado` AS `nombre_empleado`, `c`.`nombre_cliente` AS `nombre_cliente`, `p`.`nombre_producto` AS `nombre_producto`, `m`.`id_mesa` AS `id_mesa`, `v`.`fecha_venta` AS `fecha_venta`, `v`.`hora_venta` AS `hora_venta`, `v`.`total_venta` AS `total_venta` FROM ((((`ventas` `v` join `empleados` `e` on(`v`.`id_empleado` = `e`.`id_empleado`)) join `clientes` `c` on(`v`.`id_cliente` = `c`.`id_cliente`)) join `menu_productos` `p` on(`v`.`id_producto` = `p`.`id_producto`)) join `mesas` `m` on(`v`.`id_mesa` = `m`.`id_mesa`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_ventas_clientes_frecuentes`
--
DROP TABLE IF EXISTS `vista_ventas_clientes_frecuentes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_ventas_clientes_frecuentes`  AS SELECT `c`.`id_cliente` AS `id_cliente`, `c`.`nombre_cliente` AS `nombre_cliente`, count(distinct `r`.`id_reserva`) AS `total_reservas`, count(distinct `v`.`id_venta`) AS `total_compras`, count(distinct `r`.`id_reserva`) + count(distinct `v`.`id_venta`) AS `interacciones_totales` FROM ((`clientes` `c` left join `reservas` `r` on(`c`.`id_cliente` = `r`.`id_cliente`)) left join `ventas` `v` on(`c`.`id_cliente` = `v`.`id_cliente`)) GROUP BY `c`.`id_cliente`, `c`.`nombre_cliente` HAVING `interacciones_totales` > 5 ORDER BY count(distinct `r`.`id_reserva`) + count(distinct `v`.`id_venta`) DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_ventas_mensuales`
--
DROP TABLE IF EXISTS `vista_ventas_mensuales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_ventas_mensuales`  AS SELECT date_format(`ventas`.`fecha_venta`,'%Y-%m') AS `mes`, sum(`ventas`.`total_venta`) AS `ingresos_mensuales` FROM `ventas` GROUP BY date_format(`ventas`.`fecha_venta`,'%Y-%m') ORDER BY date_format(`ventas`.`fecha_venta`,'%Y-%m') DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_ventas_por_empleado`
--
DROP TABLE IF EXISTS `vista_ventas_por_empleado`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_ventas_por_empleado`  AS SELECT `e`.`nombre_empleado` AS `nombre_empleado`, count(`v`.`id_venta`) AS `total_ventas`, sum(`v`.`total_venta`) AS `ingresos_generados` FROM (`ventas` `v` join `empleados` `e` on(`v`.`id_empleado` = `e`.`id_empleado`)) GROUP BY `e`.`nombre_empleado` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias_productos`
--
ALTER TABLE `categorias_productos`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`id_empleado`),
  ADD KEY `id_rol` (`id_rol`);

--
-- Indices de la tabla `menu_productos`
--
ALTER TABLE `menu_productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `id_categoria` (`id_categoria`);

--
-- Indices de la tabla `mesas`
--
ALTER TABLE `mesas`
  ADD PRIMARY KEY (`id_mesa`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`id_reserva`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_mesa` (`id_mesa`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id_venta`),
  ADD KEY `id_empleado` (`id_empleado`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `id_mesa` (`id_mesa`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias_productos`
--
ALTER TABLE `categorias_productos`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id_empleado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `menu_productos`
--
ALTER TABLE `menu_productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `mesas`
--
ALTER TABLE `mesas`
  MODIFY `id_mesa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `id_reserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);

--
-- Filtros para la tabla `menu_productos`
--
ALTER TABLE `menu_productos`
  ADD CONSTRAINT `menu_productos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_productos` (`id_categoria`);

--
-- Filtros para la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`id_mesa`) REFERENCES `mesas` (`id_mesa`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `ventas_ibfk_3` FOREIGN KEY (`id_producto`) REFERENCES `menu_productos` (`id_producto`),
  ADD CONSTRAINT `ventas_ibfk_4` FOREIGN KEY (`id_mesa`) REFERENCES `mesas` (`id_mesa`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
