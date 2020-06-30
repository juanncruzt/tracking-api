-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 30-06-2020 a las 13:53:58
-- Versión del servidor: 5.5.62
-- Versión de PHP: 7.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tracking_api`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrier`
--

CREATE TABLE `carrier` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `carrier`
--

INSERT INTO `carrier` (`id`, `created_at`, `updated_at`, `name`) VALUES
(1, '2020-06-17 00:00:00', '2020-06-17 00:00:00', 'Andreani'),
(2, '2020-06-17 00:00:00', '2020-06-17 00:00:00', 'Chazki');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2020_06_17_181553_create_carrier_table', 1),
(2, '2020_06_18_164107_create_shipping_messages_table', 2),
(3, '2020_06_21_230713_add_icon_to_shipping_messages_table', 3),
(4, '2020_06_25_150918_add_reson_id_to_shipping_messages_table', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shipping_messages`
--

CREATE TABLE `shipping_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `carrier_id` int(11) NOT NULL,
  `carrier_status_id` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description_carrier_status` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `next_status` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` int(11) NOT NULL,
  `reason` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `shipping_messages`
--

INSERT INTO `shipping_messages` (`id`, `created_at`, `updated_at`, `carrier_id`, `carrier_status_id`, `description_carrier_status`, `message`, `next_status`, `icon`, `reason`) VALUES
(1, NULL, NULL, 2, 'A REPROGRAMAR', 'El envío falló y será reprogramado proximamente.', 'No se pudo entregar el pedido. Se programa otra visita.', 'Se visitará nuevamente el domicilio. Ingresar a https://chazki.com/argentina para más información', 5, NULL),
(2, NULL, NULL, 2, 'CANCELADO', 'Envio cancelado.', 'El envío del pedido fue cancelado.', '-', 5, NULL),
(3, NULL, NULL, 2, 'CASO REMITIDO A LA EMPRESA', 'La gestión del envío retornó al cliente', 'El pedido retornó a nuestro Centro de Distribución. Contactate con nosotros al 0800 999 0394.', 'Se deberá programar otra entrega.', 3, NULL),
(4, NULL, NULL, 2, 'COMPLETADO', 'El envío fue completado.', 'El pedido fue entregado exitosamente.', '-', 5, NULL),
(5, NULL, NULL, 2, 'CREADO', 'Envio creado', 'Ya está el envío en el sistema.', 'Sale a distribución en las próximas 24/48 horas hábiles', 1, NULL),
(6, NULL, NULL, 2, 'EN CAMINO A SER ENTREGADO', 'En camino a ser entregado (el repartidor está yendo al destino de entrega).', 'El envío esta en camino al domicilio de entrega.', 'Se entregará en las próximas horas.', 1, NULL),
(7, NULL, NULL, 2, 'EN CAMINO A SER RETIRADO', 'En camino a ser recogido (el repartidor está yendo al punto de retiro).', 'El pedido esta siendo retirado por el repartidor en el centro de distribución.', 'El pedido esta siendo retirado por el repartidor en el centro de distribución.', 1, NULL),
(8, NULL, NULL, 2, 'EN COLA', 'Envio creado pero sin gestión alguna.', 'Ya está el envío en el sistema.', 'Sale a distribución en las próximas 24/48 horas hábiles', 1, NULL),
(9, NULL, NULL, 2, 'EN CORREO', 'El paquete se encuentra en poder de Chazki', 'Ya está el envío en el sistema.', 'Sale a distribución en las próximas 24/48 horas hábiles', 2, NULL),
(10, NULL, NULL, 2, 'EN GESTION', 'El envío tuvo falló por algun motivo de caso y se requiere de una gestión manual (por parte de Chazki) para volver a intentar ser entregado o ser finalmente cancelado.', 'Ocurrió un inconveniente con el pedido. Estamos revisando lo sucedido. Contactate con nosotros al 0800 999 0394.', '-', 2, NULL),
(11, NULL, NULL, 2, 'ENTREGA ASIGNADA', 'La entrega fue despachada, esta en poder del repartidor.', 'El repartidor ya tiene el pedido en su poder.', 'Se entregará en las próximas 24 horas hábiles.', 3, NULL),
(12, NULL, NULL, 2, 'ENTREGA ASIGNADA A RUTA', 'La entrega fue despachada, esta en poder del repartidor y se encuentra en una ruta de entrega.', 'El repartidor ya tiene el pedido en su poder.', 'Se entregará en las próximas horas.', 3, NULL),
(13, NULL, NULL, 2, 'ENTREGA FALLIDA', 'Fallo al entregar el paquete.', 'Hubo un inconveniente con el proveedor logístico. Estamos averiguando lo sucedido. Contactate con nosotros al 0800 999 0394 para más información', '-', 3, NULL),
(14, NULL, NULL, 2, 'ENTREGADO', 'El envío fue completado.', 'El pedido fue entregado exitosamente.', '-', 5, NULL),
(15, NULL, NULL, 2, 'FALLO EN CAMINO AL CORREO', 'Fallo al traer el paquete a Chazki', 'Hubo un inconveniente con el proveedor logístico. Estamos averiguando lo sucedido. Contactate con nosotros al 0800 999 0394 para más información', '-', 4, NULL),
(16, NULL, NULL, 2, 'FALLO EN ENTREGA', 'Fallo al entregar el paquete.', 'No se pudo entregar el pedido. Contactate con nosotros al 0800 999 0394 para revisar la dirección de entrega informada.', '-', 5, NULL),
(17, NULL, NULL, 2, 'FALLO EN GUARDADO EN DEPOSITO', 'Fallo al traer el paquete a Chazki.', 'Hubo un inconveniente con el proveedor logístico. Estamos averiguando lo sucedido. Contactate con nosotros al 0800 999 0394 para más información', '-', 4, NULL),
(18, NULL, NULL, 2, 'FALLO EN RETIRO', 'Fallo al entregar el paquete', 'Hubo un inconveniente con el proveedor logístico. Estamos averiguando lo sucedido. Contactate con nosotros al 0800 999 0394 para más información', '-', 3, NULL),
(19, NULL, NULL, 2, 'PEDIDO CANCELADO', 'Envio cancelado.', 'Hubo un inconveniente con el proveedor logístico. Estamos averiguando lo sucedido. Contactate con nosotros al 0800 999 0394 para más información', '-', 2, NULL),
(20, NULL, NULL, 2, 'REMITIDO', 'La gestión del envío retornó al cliente', 'Hubo un inconveniente con el proveedor logístico. Estamos averiguando lo sucedido. Contactate con nosotros al 0800 999 0394 para más información', '-', 2, NULL),
(21, NULL, NULL, 2, 'RETIRO ASIGNADO', 'El retiro se encuentra dentro de la ruta de un repartidor.', 'El pedido esta siendo retirado por el repartidor en el centro de distribución.', 'Sale a distribución en las próximas 24 horas hábiles', 2, NULL),
(22, NULL, NULL, 2, 'RETIRO ASIGNADO A RUTA', 'La recolección se encuentra dentro de la ruta de un repartidor.', 'El pedido esta siendo retirado por el repartidor en el centro de distribución.', 'Sale a distribución en las próximas 24 horas hábiles', 3, NULL),
(23, NULL, NULL, 2, 'RETIRO FALLIDO', 'Fallo al recoger el paquete', 'Hubo un inconveniente con el proveedor logístico. Estamos averiguando lo sucedido. Contactate con nosotros al 0800 999 0394 para más información', '-', 3, NULL),
(24, NULL, NULL, 2, 'REVISION DE DATOS', 'El envío tuvo algún problema al crearse (normalmente es porque no se pudo ubicar la dirección) y esta parcialmente creado, deben revisarse los datos para poder avanzar con el mismo.', 'No se pudo entregar el pedido. Contactate con nosotros al 0800 999 0394 para revisar la dirección de entrega informada.', '-', 3, NULL),
(25, NULL, NULL, 2, 'YENDO A ENTREGAR', 'En camino a ser entregado (el repartidor está yendo al destino de entrega).', 'El pedido esta en camino a tu domicilio', 'Se entregará en las próximas horas.', 4, NULL),
(26, NULL, NULL, 2, 'YENDO A RETIRAR', 'En camino a ser recogido (el repartidor está yendo al punto de retiro).', 'El pedido esta siendo retirado por el repartidor en el centro de distribución.', 'Sale a distribución en las próximas 24 horas hábiles', 3, NULL),
(27, NULL, NULL, 1, '22', 'Envío en tránsito al domicilio del remitente', 'El pedido esta siendo devuelto al centro de distribución. Contactate con nosotros al 0800 999 0394 para más información', 'Se deberá programar otra entrega.', 1, NULL),
(28, NULL, NULL, 1, '23', 'Envío entregado', 'El pedido fue entregado exitosamente.', '-', 5, NULL),
(29, NULL, NULL, 1, '24', 'Envío entregado al remitente', 'El pedido se encuentra en nuestro centro de distribución.', 'Sale a distribución en las próximas 24/48 horas hábiles', 2, NULL),
(30, NULL, NULL, 1, '25', 'Envío ingresado al circuito operativo', 'El pedido ya se encuentra en distribución', 'Se entregará en los próximos días (Dependiendo ubicación geográfica).', 2, NULL),
(31, NULL, NULL, 1, '26', 'Envío no entregado', 'El pedido no pudo ser entregado por un inconveniente. Contactate con nosotros al 0800 999 0394 para más información.', 'Se deberá programar otra entrega.', 2, NULL),
(32, NULL, NULL, 1, '27', 'Envío no entregado al remitente', 'El pedido no pudo ser entregado por un inconveniente. Contactate con nosotros al 0800 999 0394 para más información.', 'Se deberá programar otra entrega.', 2, NULL),
(33, NULL, NULL, 1, '28', 'Envío no entregado en distribución al remitente', 'El pedido no pudo ser entregado y esta siendo devuelto a nuestro centro de distribución. Contactate al 0800 999 0394 para más información.', 'Se deberá programar otra entrega.', 3, NULL),
(34, NULL, NULL, 1, '29', 'Envío no entregado retornando al remitente', 'El pedido no pudo ser entregado y ya esta nuevamente en nuestro centro de distribución. Contactate con nosotros al 0800 999 0394 para más información.', 'Se deberá programar otra entrega.', 3, NULL),
(35, NULL, NULL, 1, '30', 'Envío no ingresado', 'El pedido no pudo ser enviado a la dirección ingresada. Contactate con nosotros al 0800 999 0394 para más información', 'Se deberá programar otra entrega.', 3, NULL),
(36, NULL, NULL, 1, '31', 'Envío no ingresado al circuito operativo. Para mayor información, por favor comuníquese con el Centro de Atención al Cliente a correo@andreani.com.', 'El pedido no pudo ser enviado a la dirección ingresada. Contactate con nosotros al 0800 999 0394 para más información', 'Se deberá programar otra entrega.', 3, NULL),
(37, NULL, NULL, 1, '32', 'Envío rescatado del circuito operativo por solicitud del remitente', 'El pedido esta retornando a nuestro centro de distribución debido a que se canceló durante el proceso de entrega', 'Se deberá programar otra entrega.', 3, NULL),
(38, NULL, NULL, 1, '33', 'Envío retornando al remitente', 'El pedido no pudo ser entregado y esta siendo devuelto a nuestro centro de distribución. Contactate al 0800 999 0394 para más información.', 'Se deberá programar otra entrega.', 4, NULL),
(39, NULL, NULL, 1, '34', 'La devolución no pudo ser entregada en destino. ', 'El pedido no pudo ser entregado y esta siendo devuelto a nuestro centro de distribución. Contactate al 0800 999 0394 para más información.', 'Se deberá programar otra entrega.', 4, NULL),
(40, NULL, NULL, 1, '35', 'Error interno.', 'El pedido no pudo ser entregado por un inconveniente. Contactate con nosotros al 0800 999 0394 para más información.', 'Se deberá programar otra entrega.', 4, NULL),
(41, NULL, NULL, 1, '37', 'Pedido Entregado', 'El pedido fue entregado exitosamente.', '-', 5, NULL),
(42, NULL, NULL, 1, '38', 'Pedido Entregado', 'El pedido fue entregado exitosamente.', '-', 5, NULL),
(43, NULL, NULL, 1, '39', 'Visita realizada a las XXX hs', 'Se realizó una visita al domicilio a las XX horas', 'Se realizará una nueva visita en los próximos días.', 5, NULL),
(44, NULL, NULL, 1, '40', 'No se pudo realizar la visita', 'El pedido no pudo ser entregado en el domicilio informado. Contactate con nosotros al 0800 999 0394 para más información.', 'Se deberá programar otra entrega.', 5, NULL),
(45, NULL, NULL, 1, '41', 'Envío entregado a las XXX hs', 'El pedido fue entregado exitosamente.', '-', 5, NULL),
(46, NULL, NULL, 1, '0', 'OrdenDeEnvioCreada', 'Tu pedido ingresó al sistema.', 'Será preparado por el proveedor logístico y posteriormente saldrá a distribución.', 1, NULL),
(47, NULL, NULL, 1, '1', 'AltaAutomatica', 'Tu pedido ingresó al sistema.', 'Será preparado por el proveedor logístico y posteriormente saldrá a distribución.', 1, NULL),
(48, NULL, NULL, 1, '1', 'AltaInterna', 'Tu pedido ingresó al sistema.', 'Será preparado por el proveedor logístico y posteriormente saldrá a distribución.', 1, NULL),
(49, NULL, NULL, 1, '1', 'AltaRemota', 'Tu pedido ingresó al sistema.', 'Será preparado por el proveedor logístico y posteriormente saldrá a distribución.', 1, NULL),
(50, NULL, NULL, 1, '4', 'ComienzoCustodiaEnSucursal', 'Tu pedido esta siendo procesado por el proveedor logístico.', 'Sale a distribución en las próximas 24/48 horas hábiles', 2, NULL),
(51, NULL, NULL, 1, '4', 'InicioEtapaDeGestionTelefonica', 'Tu pedido esta siendo procesado por el proveedor logístico.', 'Sale a distribución en las próximas 24/48 horas hábiles', 2, NULL),
(52, NULL, NULL, 1, '5', 'FinCustodiaEnSucursal', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, NULL),
(53, NULL, NULL, 1, '10', 'EnvioDespachado', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar el pedido.', 4, NULL),
(54, NULL, NULL, 1, '13', 'EnvioConsolidado', 'Tu pedido esta siendo procesado por el proveedor logístico.', 'Sale a distribución en las próximas 24/48 horas hábiles', 2, NULL),
(55, NULL, NULL, 1, '15', 'ExpedicionHojaDeRutaDeViaje', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, NULL),
(56, NULL, NULL, 1, '21', 'Reenvio', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, NULL),
(57, NULL, NULL, 1, '22', 'Distribucion', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, NULL),
(58, NULL, NULL, 1, '23', 'AsignacionACaja', 'Tu pedido esta siendo procesado por el proveedor logístico.', 'Sale a distribución en las próximas 24/48 horas hábiles', 2, NULL),
(59, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 20),
(60, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 131),
(61, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 11),
(62, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 22),
(63, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 26),
(64, NULL, NULL, 1, '23', 'Visita', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, 74),
(65, NULL, NULL, 1, '23', 'Visita', 'Tu pedido fue entregado exitosamente.', 'Se deberá programar otra entrega.', 5, 99),
(66, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 10),
(67, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 81),
(68, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 29),
(69, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 51),
(70, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 92),
(71, NULL, NULL, 1, '23', 'Visita', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, 3),
(72, NULL, NULL, 1, '23', 'Visita', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, 1),
(73, NULL, NULL, 1, '23', 'Visita', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, 6),
(74, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 25),
(75, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 100),
(76, NULL, NULL, 1, '23', 'Visita', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, 14),
(77, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 17),
(78, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 80),
(79, NULL, NULL, 1, '23', 'Visita', 'El domicilio fue visitado pero tu pedido no pudo ser entregado. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 23),
(80, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 76),
(81, NULL, NULL, 1, '23', 'Visita', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 71),
(82, NULL, NULL, 1, '24', 'EnvioEntregado', 'El pedido fue entregado exitosamente.', '-', 5, NULL),
(83, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, NULL),
(84, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 20),
(85, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 11),
(86, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 22),
(87, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 26),
(88, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 10),
(89, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 1),
(90, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 25),
(91, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Tu pedido fue rechazado.', 'Tu pedido esta retornando a nuestro Centro de Distribución.', 3, 14),
(92, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 17),
(93, NULL, NULL, 1, '27', 'EnvioNoEntregado', 'El domicilio fue visitado pero tu pedido no pudo ser entregado. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, 23),
(94, NULL, NULL, 1, '30', 'EnvioEnInformeDeRendicion', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, NULL),
(95, NULL, NULL, 1, '32', 'RecepcionEnSucursalDestino', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, NULL),
(96, NULL, NULL, 1, '33', 'EnvioDigitalizado', 'Tu pedido esta siendo procesado por el proveedor logístico.', 'Sale a distribución en las próximas 24/48 horas hábiles', 2, NULL),
(97, NULL, NULL, 1, '34', 'PedidoDeDestruccion', 'Tu pedido ha sido cancelado.', 'tu pedido esta retornando a nuestro Centro de Distribución.', 3, NULL),
(98, NULL, NULL, 1, '38', 'Destruccion', 'Tu pedido ha sido cancelado.', 'Tu pedido esta retornando a nuestro Centro de Distribución.', 3, NULL),
(99, NULL, NULL, 1, '41', 'EnvioRendido', 'El pedido fue entregado exitosamente.', '-', 5, NULL),
(100, NULL, NULL, 1, '42', 'Siniestro', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, NULL),
(101, NULL, NULL, 1, '46', 'CierreDeEntidad', 'Hubo un inconveniente al momento de entregar tu pedido. Contactate con nosotros al 0800 999 0392 para más información.', 'Se deberá programar otra entrega.', 3, NULL),
(102, NULL, NULL, 1, '50', 'AsignacionACaja', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, NULL),
(103, NULL, NULL, 1, '50', 'GestionTelefonica', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, 50),
(104, NULL, NULL, 1, '55', 'GestionTelefonica', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, 51),
(105, NULL, NULL, 1, '55', 'GestionTelefonica', 'Tu pedido fue rechazado.', 'Tu pedido esta retornando a nuestro Centro de Distribución.', 3, 14),
(106, NULL, NULL, 1, '55', 'GestionTelefonica', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, NULL),
(107, NULL, NULL, 1, '57', 'EnvioAnulado', 'Tu pedido ha sido cancelado.', 'Tu pedido esta retornando a nuestro Centro de Distribución.', 3, NULL),
(108, NULL, NULL, 1, '63', 'RectificacionDeMotivo', 'Tu pedido ya salió a distribución.', 'Será entregado en los plazos especificados al momento de realizar tu pedido.', 3, NULL),
(109, NULL, NULL, 1, '63', 'RectificacionDeMotivo', 'Tu pedido fue entregado exitosamente.', '-', 3, 99),
(110, NULL, NULL, 1, '86', 'Admision', 'Tu pedido esta siendo procesado por el proveedor logístico.', 'Sale a distribución en las próximas 24/48 horas hábiles', 2, NULL),
(111, NULL, NULL, 1, '100', 'EnvioPendienteDeValidacion', 'Tu pedido esta siendo procesado por el proveedor logístico.', 'Sale a distribución en las próximas 24/48 horas hábiles', 2, NULL),
(112, NULL, NULL, 1, '102', 'EnvioConDocumentacionErronea', 'Tu pedido fue entregado exitosamente.', '-', 5, 119),
(113, NULL, NULL, 1, '102', 'EnvioConDocumentacionErronea', 'Tu pedido fue entregado exitosamente.', '-', 5, 122),
(114, NULL, NULL, 1, '102', 'EnvioConDocumentacionErronea', 'Tu pedido fue entregado exitosamente.', '-', 5, 121),
(115, NULL, NULL, 1, '102', 'EnvioConDocumentacionErronea', 'Tu pedido fue entregado exitosamente.', '-', 5, 123),
(116, NULL, NULL, 1, '102', 'EnvioConDocumentacionErronea', 'Tu pedido fue entregado exitosamente.', '-', 5, 124),
(117, NULL, NULL, 1, '102', 'EnvioConDocumentacionErronea', 'Tu pedido fue entregado exitosamente.', '-', 5, 125),
(118, NULL, NULL, 1, '102', 'EnvioConDocumentacionErronea', 'Tu pedido fue entregado exitosamente.', '-', 5, 120);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `carrier`
--
ALTER TABLE `carrier`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `shipping_messages`
--
ALTER TABLE `shipping_messages`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `carrier`
--
ALTER TABLE `carrier`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `shipping_messages`
--
ALTER TABLE `shipping_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
