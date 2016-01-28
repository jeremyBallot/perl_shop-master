package Client;

use strict;

use Modele;
use Individu;
use Commande;
use Connexion;

# Hérite de Individu
our @ISA = ("Individu");

# Nom de la table en BDD
our $tableName = 'Client';

# Constructeur unique
sub new {
    my $class = shift @_;
    my $size = $#_+1;
    my $this = $class->Individu::new(@_);
    bless($this, $class);
    if ($size > 1) {
	for(my $i=0; $i<4; $i++) { shift @_; }
	$this->{adresse} = shift @_;	# Adresse
	$this->{datenaiss} = shift @_;	# Date de naissance
	$this->{civi} = shift @_;	# Civilitée
    } else {
	$this->load(shift @_);
    }
    return $this;
}

# Constructeur multiple
sub many {
    my $class = shift @_;
    my $this = {
	"clients" => []
    };
    bless($this, $class);
    $this->add(@_);
    return $this;
}

# Destructeur
sub DESTROY {
    my ($this) = @_;
    $this->Individu::DESTROY();
}

# Ajoute des clients à la liste
sub add {
    my $this = shift @_;
    if ($this->{clients} == undef) { die 'NotClientList'; }
    else {
	foreach (@_) {
	    push @{$this->{clients}}, $_;
	}
    }
}

# Représentation textuelle
sub toString {
    my ($this) = @_;
    if ($this->{clients} == undef) {
	return "[Client: ".$this->SUPER::toString().", $this->{adresse}, $this->{datenaiss}, $this->{civi}]";
    } else {
	my $out = '[Clients: ';
	$out .= join(', ', map({$_->toString()} @{$this->{clients}}));
	return $out .']';
    }
}

# Charge le client depuis la BDD
sub load {
    my ($this, $id) = @_;
    if ($id eq undef) {
	die 'UndefinedId';
	return -1;
    }
    $this->Individu::load($id);
    my $res = Modele->load($tableName, $id);
    $this->{id} = @$res[0];
    $this->{adresse} = @$res[1];
    $this->{datenaiss} = @$res[2];
    $this->{civi} = @$res[3];
}

# Enregistre du ou des client en BDD
sub store {
    my ($this) = @_;
    if ($this->{clients} == undef) {
	if (!$this->check()) { return 0; }
	my $dbh = Connexion->getDBH();
	my $sth;
	if ($this->{id} eq undef) { # Création
	    $this->Individu::store();
	    $sth = $dbh->prepare("INSERT INTO $tableName VALUES (?,?,?,?)");
	    $sth->execute($this->{id}, $this->{adresse}, $this->{datenaiss}, $this->{civi});
	} else { # Modification
	    $this->Individu::store();
	    $sth = $dbh->prepare("UPDATE $tableName SET Adresse=?, DateNaiss=?, Civi=? WHERE Id=?");
	    $sth->execute($this->{adresse}, $this->{datenaiss}, $this->{civi}, $this->{id});
	}
	$sth->finish();
	$dbh->commit();
	return 1;
    } else {
	# Pas encore implémenté !
	return -1;
    }
}

# Vérifie le client
sub check {
    my ($this) = @_;
    return (length $this->{adresse} >= 5) and (length $this->{adresse} <= 255);
}


###
#   Méthodes de classe
###

# Supprime le client de la BDD
sub remove {
    my ($class, $id) = @_;
    Commande->remove_from_client($id);
    Modele->remove($tableName, $id);
    Individu->remove($id);
}

# Crée la table
sub createTable {
    Modele->dropTable($tableName);
    my $dbh = Connexion->getDBH();
    my $sth = $dbh->prepare("CREATE TABLE $tableName (Id integer PRIMARY KEY, Adresse text NOT NULL, DateNaiss date NOT NULL, Civi text NOT NULL)");
    $sth->execute();
    $sth->finish();
    $dbh->commit();
}

sub dropTable {
    Modele->dropTable($tableName);
}

1;
