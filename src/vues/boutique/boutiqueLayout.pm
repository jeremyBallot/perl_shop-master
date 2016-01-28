#####
#   Layout partie boutique
#
#   Ce fichier construit de la partie boutique.
#   Lien de navigation des différentes catégories
#####

package boutiqueLayout;

use vue;
use CGI qw/:standard/;

sub make {
    my ($class, @cats) = @_;
    my $out;
    
    ## menu categories
    $out .= '<ul class="pure-menu-list">';
    foreach (@cats) {
	my $low = lc $_;
	$out .= '<li class="pure-menu-item"><a class="pure-menu-link" href="' .vue->path('categorie/'.$low). '">' .$_. '</a></li>';
    }
    $out .= '</ul>';
    $out .= '<a class="pure-button" href="'.vue->path('panier').'">Panier</a>';

    return $out;
}

1;
