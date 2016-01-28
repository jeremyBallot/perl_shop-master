#####
#   Formulaire pour un produit
#####

package stockProduitForm;

use vue;
use CGI qw/:standard/;

sub make {
    my ($class, %args) = @_;
    my %cats = %{$args{cats_ref}};
    my $prod = $args{produit};
    my $n = "\n";
    my $t ="\t";
    my $out = '<div class="pure-g">'.$n;

    # Image
    $out .= $t.'<div class="photo-box-u-1 u-med-1-2">'.$n;
    $out .= $t.$t.'<img class="pure-img" src="'.$prod->{photo}.'" alt="photo du produit" />'.$n;
    $out .= $t.'</div>'.$n;

    # Formulaire
    $out .= $t.'<div class="text-box-u-1 u-med-1-2">'.$n;
    if ($prod->{id} eq undef) {
	$out .= $t.$t.'<h1>Nouveau produit</h1>'.$n;
    } else {
	$out .= $t.$t.'<h1>Modifier produit</h1>'.$n;
    }

    ## Formulaire
	if ($prod->{id} eq undef) {
	    $out .= $t.$t.'<form name="produit" method="POST" action="' .vue->path('stock/produit/new'). '">'.$n;
	} else {
	    $out .= $t.$t.'<form name="produit" method="POST" action="' .vue->path('stock/produit/edit/'.$prod->{id}). '">'.$n;
	}

	# Nom
	$out .= $t.$t.$t.'<label for="nom">Nom : </label> <input type="text" name="nom" value="'.$prod->{nom}.'">'.$n;

	# Description
	$out .= $t.$t.$t.'<label for="desc">Description : </label> <textarea name="desc">'.$prod->{desc}.'</textarea>'.$n;

	# Catégorie
	$out .= $t.$t.$t.'<label for="cat">Catégorie : </label> <select name="cat">';
	foreach my $key (keys %cats) {
	    if ($cats{$key} == $prod->{cat}){
		$out .= '<option value="'.$cats{$key}.'" selected="selected">'.$key.'</option>';
	    } else{
		$out .= '<option value="'.$cats{$key}.'">'.$key.'</option>';
	    }
	}
	$out .= '</select>'.$n;

	# Prix
	$out .= $t.$t.$t.'<label for="prix">Prix unitaire : </label> <input type="text" name="prix" value="'.$prod->{prix}.'">'.$n;

	# Photo
	$out .= $t.$t.$t.'<label for="photo">Photo (url) : </label> <input type="text" name="photo" value="'.$prod->{photo}.'">'.$n;

	# Quantitée
	$out .= $t.$t.$t.'<label for="qte">Quantitée : </label> <input type="text" name="qte" value="'.$prod->{quantite}.'">'.$n;

	$out .= $t.$t.$t.'<input type="submit">'.$n;
	$out .= $t.$t.'</form>';
	$out .= $t.'</div>'.$n;

    $out .= '</div>';
    return $out;
}


1;
