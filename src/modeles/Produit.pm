package Produit;

use strict;

use Modele;
use Connexion;
use Categorie;

# Nom de la table en BDD
our $tableName = 'Produit';

# Constructeur unique
sub new {
    my $class = shift @_;
    my $size = $#_+1;
    my $this = {};
    bless($this, $class);
    if ($size > 1) {
	$this->{nom} = shift @_;    # Nom
	$this->{desc} = shift @_;   # Description
	$this->{cat} = shift @_;    # Catégorie
	$this->{prix} = shift @_;   # Prix
	$this->{photo} = shift @_;  # Uri photo
	$this->{quantite} = shift @_; # Stock
    } else {
	$this->load(shift @_);
    }
    return $this;
}

# Constructeur multiple
sub many {
    my $class = shift @_;
    my $this = {
	"produits" => []    # Tableau d'objets Produit
    };
    bless($this, $class);
    $this->add(@_);
    return $this;
}

# Ajoute des produits à la liste
sub add {
    my $this = shift @_;
    if ($this->{produits} == undef) { die 'NotProduitList'; }
    else {
	foreach (@_) {
	    push @{$this->{produits}}, $_;
	}
    }
}

# Vérifie le ou les produit(s)
sub check {
    my ($this) = @_;
	my %cats = Categorie->getCategoriesIds();
	my $catok = 0;
	foreach my $cat (%cats) {
	    if ($cat == $this->{cat}) {
		$catok = 1;
		last;
	    }
	}
	return  (length($this->{nom}) > 3 and length($this->{nom}) > 50) and (length($this->{desc}) > 3) and $catok and ($this->{prix} =~ m/\d+,\d{2}/) and (length($this->{photo}) > 1) and ($this->{quantite} =~ m/-?\d+/);
}

# Représentation textuelle
sub toString {
    my ($this) = @_;
    if ($this->{produits} == undef) {
	return "[Produit: $this->{id}, $this->{nom}, $this->{desc}, $this->{cat}, $this->{prix}, $this->{photo}, $this->{quantite}]";
    } else {
	my $out = '[Produits: ';
	$out .= join(', ', map({$_->toString()} @{$this->{produits}}));
	return $out . ']';
    }
}

# Charge le produit depuis la BDD
sub load {
    my ($this, $id) = @_;
    if ($id eq undef) {
	die 'UndefinedId';
	return -1;
    }
    my $res = Modele->load($tableName, $id);
    $this->{id} = @$res[0];
    $this->{nom} = @$res[1];
    $this->{desc} = @$res[2];
    $this->{cat} = @$res[3];
    $this->{prix} = @$res[4];
    $this->{photo} = @$res[5];
    $this->{quantite} = @$res[6];
}


# Enregistre le ou les produit en BDD
sub store {
    my ($this) = @_;
    if ($this->{produits} == undef) {
	my $dbh = Connexion->getDBH();
	my $sth;
	if ($this->{id} eq undef) { # Création
	    $this->{id} = Modele->nextId($tableName);
	    $sth = $dbh->prepare("INSERT INTO $tableName VALUES (?,?,?,?,?,?,?)");
	    $sth->execute($this->{id}, $this->{nom}, $this->{desc}, $this->{cat}, $this->{prix}, $this->{photo}, $this->{quantite});
	} else { # Modification
	    $sth = $dbh->prepare("UPDATE $tableName SET Nom=?, Desc=?, Cat=?, Prix=?, Photo=?, Quantite=? WHERE Id=?");
	    $sth->execute($this->{nom}, $this->{desc}, $this->{cat}, $this->{prix}, $this->{photo}, $this->{quantite}, $this->{id});
	}
	$sth->finish();
	$dbh->commit();
    } else {
	return -1;
    }
}

###
#   Methodes de classe
###

# Charge les produits depuis une requète SQL
sub getFromSQL {
    my ($class, $sql) = @_;
    my $dbh = Connexion->getDBH();
    my $sth = $dbh->prepare($sql);
    $sth->execute();
    my $prods = Produit->many();
    my $row;
    while ($row = $sth->fetchrow_arrayref()) {
	my $prod = Produit->new(@$row[1], @$row[2], @$row[3], @$row[4], @$row[5], @$row[6]);
	$prod->{id} = @$row[0];
	push $prods->{produits}, $prod;
    }
    $sth->finish();
    $dbh->commit();
    return $prods;
}

# Charge les produits de la catégorie
sub load_from_cat {
    my ($class, $cat) = @_;
    if ($cat =~ /^\d+$/) {
	my $sfCat = Connexion->getDBH()->quote_identifier($cat);
	return Produit->getFromSQL("SELECT * FROM $tableName WHERE Cat=$sfCat");
    } else {
	$cat =~ s/(\w)/\u\L$1/; #Met en majuscule la première lettre
	my $sfCat = Connexion->getDBH()->quote_identifier($cat);
    return Produit->getFromSQL("SELECT Produit.Id, Produit.Nom, Produit.Desc, Produit.cat, Produit.Prix, Produit.Photo, Produit.Quantite FROM Produit, Categorie WHERE Produit.Cat = Categorie.Id and Categorie.Nom = $sfCat");
    }
}

# Charge tous les produits
sub get_produits {
    my ($class) = @_;
    return Produit->getFromSQL("SELECT * FROM $tableName");
}

# Charge les produits en rupture de stock
sub get_produits_rupture {
    my ($class) = @_;
    return Produit->getFromSQL("SELECT * FROM $tableName WHERE Quantite < 1");
}

# Supprime le produit de la BDD
sub remove {
    my ($class, $id) = @_;
    Modele->remove($tableName, $id);
}

# Crée la table
sub createTable {
    Modele->dropTable($tableName);
    my $dbh = Connexion->getDBH();
    my $sf_tn = $dbh->quote_identifier($tableName);
    my $sth = $dbh->prepare("CREATE TABLE $sf_tn (Id integer PRIMARY KEY, Nom text NOT NULL, Desc text, Cat integer NOT NULL, Prix real NOT NULL, Photo text, Quantite integer DEFAULT 0, FOREIGN KEY(Cat) REFERENCES Categorie(Id))");
    $sth->execute();
    $sth->finish();
    $dbh->commit();
}

# Supprime la table
sub dropTable {
    Modele->dropTable($tableName);
}

1;
