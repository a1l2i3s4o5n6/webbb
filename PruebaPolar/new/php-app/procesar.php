<?php
declare(strict_types=1);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
header('Location: formulario.html');
exit;
}
$errores = [];

$nombre = filter_input(INPUT_POST, 'nombre', FILTER_DEFAULT);
$nombre = htmlspecialchars(trim($nombre ?? ''), ENT_QUOTES, 'UTF-8');
if (empty($nombre)) {
$errores['nombre'] = 'El nombre no puede estar vacio.';
} elseif (strlen($nombre) < 2 || strlen($nombre) > 100) {
$errores['nombre'] = 'El nombre debe tener entre 2 y 100 caracteres.';
}

$email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
if ($email === false || $email === null) {
$errores['email'] = 'El correo electronico no tiene un formato valido.';
} else {
$email = htmlspecialchars($email, ENT_QUOTES, 'UTF-8');
}

$opcionesEdad = ['options' => ['min_range' => 1, 'max_range' => 120]];
$edad = filter_input(INPUT_POST, 'edad', FILTER_VALIDATE_INT, $opcionesEdad);
if ($edad === false || $edad === null) {
$errores['edad'] = 'La edad debe ser un numero entero entre 1 y 120.';
}

$mensaje = filter_input(INPUT_POST, 'mensaje', FILTER_DEFAULT);
$mensaje = htmlspecialchars(trim($mensaje ?? ''), ENT_QUOTES, 'UTF-8');
if (empty($mensaje)) {
$errores['mensaje'] = 'El mensaje no puede estar vacio.';
} elseif (strlen($mensaje) > 500) {
$errores['mensaje'] = 'El mensaje no puede superar los 500 caracteres.';
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Resultado PHP</title>
<style>
body { font-family: Arial, sans-serif; max-width: 600px; margin: 2rem auto; padding: 0 1rem; }
.error { color: #a32929; background: #fffbfb; padding: 8px 12px; border-radius: 4px; border-left: 4px solid #efe9e9; margin: 4px 0; }
.exito { color: #c2d8cb; background: #f4fdf7; padding: 8px 12px; border-radius: 4px; border-left: 4px solid #fbfbfb; margin: 4px 0; }
table { width: 100%; border-collapse: collapse; }
td, th { padding: 8px 12px; border: 1px solid #efefef80; text-align: left; }
th { background: #535699; color: white; }
tr:nth-child(even) { background: #f5f5f5; }
.badge { display: inline-block; padding: 2px 10px; border-radius: 12px; font-size: 0.8rem; background: #7779b3; color: white; }
</style>
</head>
<body>
<h1><span class="badge">PHP 8.2</span> Resultado del procesamiento</h1>

<?php if (!empty($errores)): ?>
<h2 style="color:#c0392b;">Se encontraron errores:</h2>
<?php foreach ($errores as $campo => $msg): ?>
<div class="error">
<strong><?= htmlspecialchars(ucfirst($campo), ENT_QUOTES, 'UTF-8') ?>:</strong> <?= $msg ?>
</div>
<?php endforeach; ?>

<?php else: ?>
<div class="exito"><strong>Datos recibidos y validados correctamente.</strong></div>
<h2>Resumen de los datos:</h2>
<table>
<tr><th>Campo</th><th>Valor recibido</th></tr>
<tr><td>Nombre</td><td><?= $nombre ?></td></tr>
<tr><td>Email</td><td><?= $email ?></td></tr>
<tr><td>Edad</td><td><?= $edad ?> anos</td></tr>
<tr><td>Mensaje</td><td><?= $mensaje ?></td></tr>
</table>
<?php endif; ?>

<p><a href="formulario.html">&larr; Volver al formulario</a></p>
<hr>
<p style="font-size:0.8rem; color:#888;">
Procesado por PHP <?= phpversion() ?> | Metodo: POST | IP: <?= htmlspecialchars($_SERVER['REMOTE_ADDR'] ?? 'desconocida', ENT_QUOTES, 'UTF-8') ?>
</p>
</body>
</html>
