######
#   Liste de produits
######

package stockProduits;

use vue;

sub make {
    my ($this, %args) = @_;
    my $n = "\n";
    my $t = "\t";
    my $out = '<div>'.$n;

    $out .= '<h1>'.$args{titre}.'</h1>';

    $out .= '<table class="pure-table pure-table-bordered pure-table-striped">'.$n;
    $out .= $t.'<thead><tr>'.$n;
    $out .= $t.$t.'<th>Ref.</th><th>Nom</th><th>Prix</th><th>Stock</th><th>Actions</th>'.$n;
    $out .= $t.'</tr></thead>'.$n;
    $out .= $t.'<tbody>'.$n;
    foreach (@{$args{produits}->{produits}}) {
	$out .= $t.$t.'<tr>'.$n;
	$out .= $t.$t.$t.'<td class="adroite"><a href="'.vue->path('produit/'.$_->{id}).'">'.$_->{id}.'</a></td>'.$n;
	$out .= $t.$t.$t.'<td>'.$_->{nom}.'</td>'.$n;
	$out .= $t.$t.$t.'<td class="adroite">'.$_->{prix}.'€</td>'.$n;
	$out .= $t.$t.$t.'<td class="adroite">'.$_->{quantite}.'</td>'.$n;
	$out .= $t.$t.$t.'<td><a href="'.vue->path('stock/produit/edit/'.$_->{id}).'">Modifier</a> <a href="'.vue->path('stock/produit/delete/'.$_->{id}).'">Supprimer</a></td>'.$n;
	$out .= $t.$t.'</tr>'.$n;
    }
    $out .= $t.'</tbody>'.$n;
    $out .= '</table>'.$n;

    $out .= '</div>'.$n;

    return $out;
}


1;
