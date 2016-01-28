package Commande;

use strict;

use Modele;
use Connexion;

# Nom de la table en BDD
our $tableName = 'Commande';

# Constructeur unique
sub new {
    my $class = shift @_;
    my $size = $#_+1;
    my $this = {};
    bless($this, $class);
    if ($size > 1) {
	$this->{client} = shift @_;	# Num client
	$this->{dateC} = shift @_;	# Date de la commande
	$this->{dateE} = shift @_;	# Date d'envoi
	$this->{dateP} = shift @_;	# Date de paiement
    } else {
	$this->load(shift @_);
    }
    return $this;
}

# Constructeur multiple
sub many {
    my $class = shift @_;
    my $this = {
	"commandes" => []	# Tableau d'objets Commande
    };
    bless($this, $class);
    $this->add(@_);
    return $this;
}

# Ajoute des commandes à la liste
sub add {
    my $this = shift @_;
    if ($this->{commandes} == undef) { die 'NotCommandeList'; }
    else {
	foreach (@_) {
	    push @{$this->{commandes}}, $_;
	}
    }
}

# Représentation textuelle
sub toString {
    my ($this) = @_;
    if ($this->{commandes} == undef) {
	return "[Commande: $this->{id}, $this->{client}, $this->{dateC}, $this->{dateE}, $this->{dateP}]";
    } else {
	my $out = '[Commandes: ';
	$out .= join(', ', map({$_->toString()} @{$this->{commandes}}));
	return $out . ']';
    }
}

# Charge la commande depuis la BDD
sub load {
    my ($this, $id) = @_;
    if ($id eq undef) {
	die 'UndefinedId';
	return -1;
    }
    my $res = Modele->load($tableName, $id);
    $this->{id} = @$res[0];
    $this->{client} = @$res[1];
    $this->{dateC} = @$res[2];
    $this->{dateE} = @$res[3];
    $this->{dateP} = @$res[4];
}

# Enregistre la ou les commande en BDD
sub store {
    my ($this) = @_;
    if ($this->{commandes} == undef) {
	if (!$this->check()) { return 0;}
	my $dbh = Connexion->getDBH();
	my $sth;
	if ($this->{id} eq undef) { # Création
	    $this->{id} = Modele->nextId($tableName);
	    $sth = $dbh->prepare("INSERT INTO $tableName VALUES (?,?,?,?,?)");
	    $sth->execute($this->{id}, $this->{client}, $this->{dateC}, $this->{dateE}, $this->{dateP});
	} else { # Modification
	    $sth = $dbh->prepare("UPDATE $tableName SET Client=?, DateC=?, DateE=?, DateP=? WHERE Id=?");
	    $sth->execute($this->{client}, $this->{dateC}, $this->{dateE}, $this->{dateP}, $this->{id});
	}
	$sth->finish();
	$dbh->commit();
    } else {
	return -1;
    }
}

# Vérifie la commande
sub check {
    my ($this) = @_;
    return ($this->{client} =~ m/\d+/) and ($this->{dateC} eq '' or isDate($this->{dateC})) and ($this->{dateE} eq '' or isDate($this->{dateE})) and ($this->{dateP} eq '' or isDate($this->{dateP}));
}

# Vérifie une date
sub isDate {
    my ($date) = @_;
    return $date =~ m/\d{4}-\d{2}-\d{2}/;
}

###
#   Méthodes de classe
###

# Supprime la commande de la BDD
sub remove {
    my ($class, $id) = @_;
    ProdCom->remove_from_commande($id);
    Modele->remove($tableName, $id);
}

# Supprime toutes les commandes du client
sub remove_from_client {
    my ($class, $id_client) = @_;
    my $dbh = Connexion->getDBH();
    my $sth = $dbh->prepare("DELETE FROM $tableName WHERE Client=?");
    $sth->execute($id_client);
    $sth->finish();
    $dbh->commit();
}

# Récupère toutes les commandes non traités
sub get_no_spray {
    my ($this) = @_;
    return $this->getFromSQL("SELECT * FROM $tableName WHERE DateE = ''");
}

# Récupère toutes les commandes envoyé
sub get_send {
    my ($this) = @_;
    return $this->getFromSQL("SELECT * FROM $tableName WHERE DateE <> ''");
}

# Récupère toutes les commandes
sub get_commandes {
    my ($this) = @_;
    return $this->getFromSQL("SELECT * FROM $tableName");
}

# Récupère les commandes a partir d'une requète
sub getFromSQL {
    my ($class, $sql) = @_;
    my $dbh = Connexion->getDBH();
    my $sth = $dbh->prepare($sql);
    $sth->execute();
    my $coms = Commande->many();
    my $row;
    while ($row = $sth->fetchrow_arrayref()) {
	my $com = Commande->new(@$row[1], @$row[2], @$row[3], @$row[4]);
	$com->{id} = @$row[0];
	push $coms->{commandes}, $com;
    }
    $sth->finish();
    $dbh->commit();
    return $coms;
}

# Crée la table
sub createTable {
    Modele->dropTable($tableName);
    my $dbh = Connexion->getDBH();
    my $sth = $dbh->prepare("CREATE TABLE $tableName (Id integer PRIMARY KEY, Client integer NOT NULL, DateC date NOT NULL, DateE date, DateP date, FOREIGN KEY(Client) REFERENCES Client(Id))");
    $sth->execute();
    $sth->finish();
    $dbh->commit();
}

# Supprime la table
sub dropTable {
    Modele->dropTable($tableName);
}

1;
