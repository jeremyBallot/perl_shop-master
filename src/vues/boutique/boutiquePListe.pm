######
#   Petite Liste
#
#   Ce fichier fait une liste de certains produits.
#   Grande image, petite description
#####

package boutiquePListe;

use vue;
use CGI qw/:standard/;


sub make {
    my ($class, %args) = @_;
    my $n = "\n";
    my $t = "\t";
    my $out = '<div>'.$n;

    #$out .= $args{produits}->toString();

    $out .= $t.'<h1>'.$args{titre}.'</h1>'.$n;

    $out .= '<table class="pure-table pure-table-bordered pure-table-striped">'.$n;
    $out .= $t.'<thead><tr>'.$n;
    $out .= $t.$t.'<th>Nom</th><th>Description</th><th>Prix</th><th>Disponibilité</th>'.$n;
    $out .= $t.'</tr></thead>'.$n;
    $out .= $t.'<tbody>'.$n;
    foreach (@{$args{produits}->{produits}}) {
	my $desc = substr($_->{desc},0,50); $desc =~ s/\n//g;
	my $dispo; if($_->{quantite}>0){$dispo='Disponible';}else{$dispo='Indisponible';}
	$out .= $t.$t.'<tr>'.$n;
	$out .= $t.$t.$t.'<td><a href="'.vue->path('produit/'.$_->{id}).'">'.$_->{nom}.'</a></td>'.$n;
	$out .= $t.$t.$t.'<td>'.$desc.'...</td>'.$n;
	$out .= $t.$t.$t.'<td>'.$_->{prix}.'€</td>'.$n;
	$out .= $t.$t.$t.'<td>'.$dispo.'</td>'.$n;
	$out .= $t.$t.'</tr>'.$n;
    }
    $out .= $t.'</tbody>'.$n;
    $out .= '</table>'.$n;

    $out .= '</div>';

    return $out;
}

1;
