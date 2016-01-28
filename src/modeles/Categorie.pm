package Categorie;

use strict;

use Modele;
use Connexion;

# Nom de la table en BDD
our $tableName = 'Categorie';

# Constructeur unique
sub new {
    my $class = shift @_;
    my $size = $#_+1;
    my $this = {};
    bless($this, $class);
    if ($size > 1) {
	$this->{nom} = shift @_;    # Nom de la catégorie
	$this->{parent} = shift @_; # Catégorie père
    } else {
	$this->load(shift @_);
    }
    return $this;
}

# Constructeur multiple
sub many {
    my $class = shift @_;
    my $this = {
	"cats" => []	# Tableau d'objets Categorie
    };
    bless($this, $class);
    $this->add(@_);
    return $this;
}

# Ajoute des catégories à la liste
sub add {
    my $this = shift @_;
    if ($this->{cats} == undef) { die 'NotCategorieList'; }
    else {
	foreach (@_) {
	    push @{$this->{cats}}, $_;
	}
    }
}

# Représentation textuelle
sub toString {
    my ($this) = @_;
    if ($this->{cats} == undef) {
	return "[Categorie: $this->{id}, $this->{nom}, $this->{parent}]";
    } else {
	my $out = '[Categories: ';
	$out .= join(', ', map({$_->toString()} @{$this->{cats}}));
	return $out . ']';
    }
}

# Charge la catégorie depuis la BDD
sub load {
    my ($this, $id) = @_;
    if ($id eq undef) {
	die 'UndefinedId';
	return -1;
    }
    my $res = Modele->load($tableName, $id);
    $this->{id} = @$res[0];
    $this->{nom} = @$res[1];
    $this->{parent} = @$res[2];
}

# Enregistre la ou les catégorie en BDD
sub store {
    my ($this) = @_;
    if ($this->{categories} == undef) {
	if (!$this->check()) { return 0; }
	my $dbh = Connexion->getDBH();
	my $sth;
	if ($this->{id} eq undef) { # Création
	    $this->{id} = Modele->nextId($tableName);
	    $sth = $dbh->prepare("INSERT INTO $tableName VALUES (?,?,?)");
	    $sth->execute($this->{id}, $this->{nom}, $this->{parent});
	} else { # Modification
	    $sth = $dbh->prepare("UPDATE $tableName SET Nom=?, Parent=? WHERE Id=?");
	    $sth->execute($this->{nom}, $this->{parent}, $this->{id});
	}
	$sth->finish(); $dbh->commit();
	return 1;
    } else {
	# Pas encore implémenté !
	return -1;
    }
}

# vérifie la catégorie
sub check {
    my ($this) = @_;
    # première lettre en majuscule et le reste en minuscule
    return ($this->{nom} =~ m/[A-Z][a-z]*/) and (length $this->{nom} >= 2) and (length $this->{nom} <= 25);
}

###
#   Methodes de classe
###

# Retourne la liste des categories
sub getCategories {
    my $dbh = Connexion->getDBH();
    my @cats;
    my $sth = $dbh->prepare("SELECT Nom FROM $tableName");
    $sth->execute();
    while ( my ($cat) = $sth->fetchrow_array ) {
	push (@cats, $cat);
    }
    $sth->finish();
    $dbh->commit();
    return @cats;
}

# Retourne les id des catégories
sub getCategoriesIds {
    my $dbh = Connexion->getDBH();
    my @ids;
    my $sth = $dbh->prepare("SELECT Id FROM $tableName");
    $sth->execute();
    while (my($id) = $sth->fetchrow_array) {
	push (@ids, $id);
    }
    $sth->finish();
    $dbh->commit();
    return @ids;
}

# Retourne les catégories sous forme de hash
sub getCategoriesHash {
    my $dbh = Connexion->getDBH();
    my %cats;
    my $sth = $dbh->prepare("SELECT Id,Nom FROM $tableName");
    $sth->execute();
    while (my($id,$nom) = $sth->fetchrow_array) {
	$cats{$nom} = $id;
    }
    $sth->finish();
    $dbh->commit();
    return %cats;
}

# Supprime la catégorie de la BDD
sub delete {
    my ($class, $id) = @_;
    Modele->remove($tableName, $id);
}

# Crée la table
sub createTable {
    Modele->dropTable($tableName);
    my $dbh = Connexion->getDBH();
    my $sth = $dbh->prepare("CREATE TABLE $tableName (Id integer PRIMARY KEY, Nom text NOT NULL, Parent integer)");
    $sth->execute();
    $sth->finish();
    $dbh->commit();
}

# Supprime la table
sub dropTable {
    Modele->dropTable($tableName);
}

1;
