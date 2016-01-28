###
#   Panier
#
#   Affiche les produits du panier
###

package boutiquePanier;

use vue;
use CGI qw/:standard/;

sub make {
    my ($class, %args) = @_;
    my $n = "\n";
    my $t = "\t";
    my $out = '<div>'.$n;

    $out .= $t.'<h1>Mon panier</h1>'.$n;

    $out .= '<table class="pure-table pure-table-bordered">'.$n;
    $out .= $t.'<thead><tr>'.$n;
    $out .= $t.$t.'<th>Produit</th><th>Prix u.</th><th>Quantité</th><th>Prix t.</th><th>Action</th>'.$n;
    $out .= $t.'</tr></thead>'.$n;
    $out .= $t.'<tbody>'.$n;
    my $total = 0;
    foreach (@{$args{produits}->{produits}}) {
	my $pu=$_->{prix}; $pu=~s/,/\./; my $pt=$pu*$_->{quantite}; $total+=$pt; $pt=~s/\./,/;
	$out .= $t.$t.'<tr>'.$n;
	$out .= $t.$t.$t.'<td><a href="'.vue->path('produit/'.$_->{id}).'">'.$_->{nom}.'</a></td>'.$n;
	$out .= $t.$t.$t.'<td class="adroite">'.$_->{prix}.'€</td>'.$n;
	$out .= $t.$t.$t.'<td class="adroite">'.$_->{quantite}.'</td>'.$n;
	$out .= $t.$t.$t.'<td class="adroite">'.$pt.'€</td>'.$n;
	$out .= $t.$t.$t.'<td><a href="'.vue->path('panier/delete/'.$_->{id}).'">Supprimer</a></td>'.$n;
	$out .= $t.$t.'</tr>'.$n;
    }
    if ($args{taille} < 1) {
	$out .= $t.$t.'<tr><td colspan="5">Le panier est vide.</td></tr>'.$n;
    }
    $out .= $t.'</tbody>'.$n;
    $out .= '</table>'.$n;

    $total =~ s/\./,/;
    $out .= '<p>Total : '.$total.'€</p>'.$n;

    $out .= '<a href="'.vue->path('commander').'">Passer la commande</a>'.$n;

    $out .= '</div>'.$n;
    return $out;
}
 1;
