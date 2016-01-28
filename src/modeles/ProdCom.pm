package ProdCom;

use strict;

use Modele;
use Connexion;

# Nom de la table en BDD
our $tableName = 'ProdCom';

# Constructeur unique
sub new {
    my $class = shift @_;
    my $size = $#_+1;
    my $this = {};
    bless($this, $class);
    if ($size > 1) {
	$this->{produit} = shift @_;    # Num produit#}
	$this->{commande} = shift @_;	# Num commande
	$this->{quantitee} = shift @_;	# Quantitée
    } else {
	$this->load(shift @_);
    }
    return $this;
}

# Constructeur multiple
sub many {
    my $class = shift @_;
    my $this = {
	"prodsComs" => []    # Tableau de produits commandés
    };
    bless($this, $class);
    $this->add(@_);
    return $this;
}

# Destructeur
sub DESTROY {
    my ($this) = @_;
    $this->Modele::DESTROY();
}

# Ajoute des produits commandés à la liste
sub add {
    my $this = shift @_;
    if ($this->{prodsComs} == undef) { die 'NotProdComList'; }
    else {
	foreach (@_) {
	    push @{$this->{prodsComs}}, $_;
	}
    }
}

# représentation textuelle
sub toString {
    my ($this) = @_;
    if ($this->{prodsComs} == undef) {
	return "[ProduitCommande: $this->{id}, $this->{produit}, $this->{commande}, $this->{quantitee}]";
    } else {
	my $out = '[ProduitsCommandes: ';
	$out .= join(', ', map({$_->toString()} @{$this->{prodsComs}}));
	return $out . ']';
    }
}

# Charge le produit commandé depuis la BDD
sub load {
    my ($this, $id) = @_;
    if ($id eq undef) {
	die 'UndefinedId';
	return -1;
    }
    my $res = Modele->load($tableName, $id);
    $this->{id} = @$res[0];
    $this->{produit} = @$res[1];
    $this->{commande} = @$res[2];
    $this->{quantitee} = @$res[3];
}

# Enregistre le ou les produit commandé en BDD
sub store {
    my ($this) = @_;
    if ($this->{ProdsComs} == undef) {
	if (!$this->check()) { return 0; }
	my $dbh = Connexion->getDBH();
	my $sth;
	if ($this->{id} eq undef) { # Création
	    $this->{id} = Modele->nextId($tableName);
	    $sth = $dbh->prepare("INSERT INTO $tableName VALUES (?,?,?,?)");
	    $sth->execute($this->{id}, $this->{produit}, $this->{commande}, $this->{quantitee});
	} else { # Modification
	    $sth = $dbh->prepare("UPDATE $tableName SET Produit=?, Commande=?, Quantitee=? WHERE Id=?");
	    $sth->execute($this->{produit}, $this->{commande}, $this->{quantitee}, $this->{id});
	}
	$sth->finish();
	$dbh->commit();
	return 1;
    } else {
	return -1;
    }
}

# Vérifie un produit commandé
sub check {
    my ($this) = @_;
    return ($this->{produit} =~ m/\d+/) and ($this->{commande} =~ m/\d+/) and ($this->{quantitee} =~ m/\d+/);
}

###
#   Méthodes de classe
###

# Récupère tous les produits de la commande
sub get_from_com {
    my ($class, $idCom) = @_;
    my $dbh = Connexion->getDBH();
    my $sth = $dbh->prepare("SELECT Produit.Id, Produit.Nom, ProdCom.Quantitee, Produit.prix FROM Produit, ProdCom WHERE ProdCom.Produit = Produit.Id AND ProdCom.Commande = ?");
    $sth->execute($idCom);
    my $prods = ProdCom->many();
    my $row;
    while ($row = $sth->fetchrow_arrayref()) {
	my $prod = ProdCom->new(@$row[0], $idCom, @$row[2]);
	$prod->{nom} = @$row[1]; $prod->{prix} = @$row[3];
	push $prods->{prodsComs}, $prod;
    }
    $sth->finish();
    $dbh->commit();
    return $prods;
}

# Supprime le produit commandé de la BDD
sub remove {
    my ($this, $id) = @_;
    Modele->remove($tableName, $id);
}

# Supprime tous les produits commandés de la commande
sub remove_from_commande {
    my ($class, $id_com) = @_;
    my $dbh = Connexion->getDBH();
    my $sth = $dbh->prepare("DELETE FROM $tableName WHERE Commande=?");
    $sth->execute($id_com);
    $sth->finish();
    $dbh->commit();
}

# Crée la table
sub createTable {
    Modele->dropTable($tableName);
    my $dbh = Connexion->getDBH();
    my $sth = $dbh->prepare("CREATE TABLE $tableName (Id integer PRIMARY KEY, Produit integer NOT NULL, Commande integer NOT NULL, Quantitee integer default 1, FOREIGN KEY(Produit) REFERENCES Produit(Id), FOREIGN KEY(Commande) REFERENCES Commande(Id))");
    $sth->execute();
    $sth->finish();
    $dbh->commit();
}

# Supprime la table
sub dropTable {
    Modele->dropTable($tableName);
}

1;
