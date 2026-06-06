use CGI::Emulate::PSGI;
use CGI::Compile;

my $script = CGI::Compile->compile("/app/procesar.pl");
my $app = CGI::Emulate::PSGI->handler($script);

$app;
