#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi = CGI->new;
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

my $nombre = $cgi->param('nombre') // '';
my $email = $cgi->param('email') // '';
my $edad = $cgi->param('edad') // '';
my $mensaje = $cgi->param('mensaje') // '';

my $metodo = $cgi->request_method() // '';
if ($metodo ne 'POST') {
print $cgi->redirect('http://localhost:8080/formulario.html');
exit;
}

sub sanear {
my ($texto) = @_;
$texto = CGI::escapeHTML($texto);
$texto =~ s/^\s+|\s+$//g;
return $texto;
}

my %errores;

$nombre = sanear($nombre);
if (length($nombre) < 2) {
$errores{nombre} = 'El nombre no puede estar vacio.';
} elsif (length($nombre) > 100) {
$errores{nombre} = 'El nombre no puede superar los 100 caracteres.';
}

$email = sanear($email);
unless ($email =~ /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/) {
$errores{email} = 'El correo electronico no tiene formato valido.';
}

$edad = sanear($edad);
unless ($edad =~ /^\d+$/ && $edad >= 1 && $edad <= 120) {
$errores{edad} = 'La edad debe ser un numero entero entre 1 y 120.';
}

$mensaje = sanear($mensaje);
if (length($mensaje) == 0) {
$errores{mensaje} = 'El mensaje no puede estar vacio.';
} elsif (length($mensaje) > 500) {
$errores{mensaje} = 'El mensaje no puede superar los 500 caracteres.';
}

my $version_perl = sprintf("%vd", $^V);

print <<HTML_INICIO;
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Resultado PERL/CGI</title>
<style>
body { font-family: Arial, sans-serif; max-width: 600px; margin: 2rem auto; padding: 0 1rem; }
.error { color: #c0392b; background: #ffffff; padding: 8px 12px; border-radius: 4px; border-left: 4px solid #c0392b; margin: 4px 0; }
.exito { color: #1e6b3c; background: #eaf5ee; padding: 8px 12px; border-radius: 4px; border-left: 4px solid #1e6b3c; }
table { width:100%; border-collapse: collapse; }
td, th { padding:8px 12px; border:1px solid #ddd; }
th { background: #3d8b3d; color: white; }
tr:nth-child(even) { background: #f5f5f5; }
.badge { display: inline-block; padding:2px 10px; border-radius:12px; font-size:0.8rem; background: #3d8b3d; color: white; }
</style>
</head>
<body>
<h1><span class="badge">PERL/CGI</span> Resultado del procesamiento</h1>
HTML_INICIO

if (%errores) {
print "<h2 style='color:#c0392b;'>Se encontraron errores:</h2>\n";
foreach my $campo (sort keys %errores) {
my $campo_display = ucfirst($campo);
print "<div class='error'><strong>$campo_display:</strong> " . $errores{$campo} . "</div>\n";
}
} else {
print "<div class='exito'>";
print "<strong>Datos recibidos y validados correctamente.</strong> ";
print "</div>\n";
print "<h2>Resumen de los datos:</h2>\n";
print "<table>\n";
print "<tr><th>Campo</th><th>Valor recibido</th></tr>\n";
print "<tr><td>Nombre</td><td>$nombre</td></tr>\n";
print "<tr><td>Email</td><td>$email</td></tr>\n";
print "<tr><td>Edad</td><td>$edad anos</td></tr>\n";
print "<tr><td>Mensaje</td><td>$mensaje</td></tr>\n";
print "</table>\n";
}

print <<HTML_FIN;
<p><a href="http://localhost:8080/formulario.html">&larr; Volver</a></p>
<hr>
<p style="font-size:0.8rem; color:#888;">
Procesado por Perl $version_perl con CGI.pm | Metodo: POST | IP: $ENV{REMOTE_ADDR}
</p>
</body>
</html>
HTML_FIN
