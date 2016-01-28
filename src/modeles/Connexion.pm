###			###
#   Objet de connexion	  #
#	Singleton	  #
###			###

package Connexion;
use DBI;
use strict;

our $instance = undef;

# Constructeur
sub new {
    my $class = shift @_;
    my $dsn = "DBI:SQLite:dbname=perlshop.db";
    my $dbh =  DBI->connect($dsn,"","",{ RaiseError => 1 },) or die $DBI::errstr;
    $dbh->{AutoCommit} = 0;
    my $this = {
	"dsn" => $dsn,
	"dbh" => $dbh
    };
    bless($this, $class);
    return $this;
}

# Accesseur de l'instance
sub getInstance {
    if ($instance == undef) {
	$instance = Connexion->new();
    }
    return $instance;
}

# Accesseur du handler
sub getDBH {
    my $con = Connexion->getInstance();
    return $con->{dbh};
}

# Destructeur
sub DESTROY {
    $instance->{dbh}->disconnect();
}

1;
