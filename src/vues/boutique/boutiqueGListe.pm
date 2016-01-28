######
#   Grande Liste
#
#   Ce fichier fait une grande liste de produits sous forme de tableau
######

package boutiqueGListe;

use vue;
use CGI qw/:standard/;

sub make {
    my ($class, $produits) = @_;
    my $out = '';
    my $n = "\n";
    my $t = "\t";

    $out .= '<div id="mosa" class="pure-g">'.$n;

    # Box text
    $out .= $t.'<div class="text-box u-1 u-med-1 u-lrg-2-3">'.$n;
    $out .= $t.$t.'<div class="l-box">'.$n;
    $out .= $t.$t.$t.'<h1 class="text-box-head">Grande braderie de printemps !</h1>'.$n;
    $out .= $t.$t.$t.'<p class="text-box-subhead">De nombreuses réductions dans tous les rayons.</p>'.$n;
    $out .= $t.$t.'</div>'.$n;
    $out .= $t.'</div>'.$n;

    foreach (@{$produits->{produits}}) {
	$out .= $t.'<div class="photo-box u-1 u-med-1-2 u-lrg-1-3">'.$n;
	$out .= $t.$t.'<a href="'.vue->path('produit/'.$_->{id}).'">'.$n;
	$out .= $t.$t.$t.'<img src="'.$_->{photo}.'" alt="'.$_->{nom}.'">'.$n;
	$out .= $t.$t.'</a>'.$n;
	$out .= $t.$t.'<aside class="photo-box-caption"><span><div>'.$_->{prix}.'€</div></span></aside>'.$n;
	$out .= $t.'</div>'.$n;
    }

    $out .= '</div>'.$n;

    return $out;
}

1;
