###		    ###
#   Objet de modèle   #
#      Interface      #
###		    ###

package Modele;
use DBI;
use strict;
use Connexion;


# Génère un id
sub nextId {
    my ($class, $tableName) = @_;
    my $dbh = Connexion->getDBH();
    my $sf_tn = $dbh->quote_identifier($tableName);
    my $sth = $dbh->prepare("SELECT max(Id)+1 FROM $sf_tn");
    $sth->execute();
    my $res = $sth->fetchrow_arrayref();
    $sth->finish();
    $dbh->commit();
    if (@$res[0] == "") {
	return 0;
    } else {
	return @$res[0];
    }
}

# Charge un objet
sub load {
    my ($class, $tableName, $id) = @_;
    my $dbh = Connexion->getDBH();
    my $sf_tn = $dbh->quote_identifier($tableName);
    my $sth = $dbh->prepare("SELECT * FROM $sf_tn WHERE Id = ?");
    $sth->execute($id);
    my $res = $sth->fetchrow_arrayref();
    $sth->finish();
    $dbh->commit();
    return $res;
}

# Supprime un objet de la table
sub remove {
    my ($class, $tableName, $id) = @_;
    my $dbh = Connexion->getDBH();
    my $sf_tn = $dbh->quote_identifier($tableName);
    my $sth = $dbh->prepare("DELETE FROM $sf_tn WHERE Id=?");
    $sth->execute($id);
    $sth->finish();
    $dbh->commit();
}

# Supression de table
sub dropTable {
    my ($class, $tableName) = @_;
    my $dbh = Connexion->getDBH();
    my $sf_tn = $dbh->quote_identifier($tableName);
    my $sth = $dbh->prepare("DROP TABLE IF EXISTS $sf_tn");
    $sth->execute();
    $sth->finish();
    $dbh->commit();
}

1;
