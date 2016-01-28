#####
#   Détail commande
#
####

package stockCommande;

use vue;
use CGI qw/:standard/;

sub make {
    my ($class, %args) = @_;
    my $n = "\n";
    my $t = "\t";
    my $out = '<div>'.$n;

    $out .= $t.'<h1>'.$args{titre}.'</h1>'.$n;

    # détail de la commande
    $out .= '<table class="pure-table pure-table-bordered pure-table-striped">'.$n;
    $out .= $t.'<thead><tr>'.$n;
    $out .= $t.$t.'<th>Ref.</th><th>Nom</th><th>Prix U.</th><th>Qté.</th><th>Prix T.</th>'.$n;
    $out .= $t.'</tr></thead>'.$n;
    $out .= $t.'<tbody>'.$n;
    my $total = 0;
    foreach (@{$args{produits}->{prodsComs}}) {
	my $pu=$_->{prix}; $pu=~s/,/\./; my $pt=$pu*$_->{quantitee}; $total+=$pt; $pt=~s/\./,/;
	$out .= $t.$t.'<tr>'.$n;
	$out .= $t.$t.$t.'<td class="adroite"><a href="'.vue->path('produit/'.$_->{produit}).'">'.$_->{produit}.'</a></td>'.$n;
	$out .= $t.$t.$t.'<td>'.$_->{nom}.'</td>'.$n;
	$out .= $t.$t.$t.'<td class="adroite">'.$_->{prix}.'€</td>'.$n;
	$out .= $t.$t.$t.'<td class="adroite">'.$_->{quantitee}.'</td>'.$n;
	$out .= $t.$t.$t.'<td class="adroite">'.$pt.'€</td>'.$n;
	$out .= $t.$t.'</tr>'.$n;
    }
    $out.= $t.'</tbody>'.$n;
    $out .= '</table>'.$n;

    $total =~ s/\./,/;
    $out .= '<p>Total : '.$total.'€</p>'.$n;

    # Commande
    $out .= '<p>'.$args{commande}->toString().'</p>'.$n;

    # Données du client
    $out .= '<p>'.$args{client}->toString().'</p>'.$n;

    # afficher si non expédié
    if ($args{commande}->{dateE} eq undef) {
	$out .= '<a href="'.vue->path('stock/commande/exp/'.$args{commande}->{id}).'">Expédier la commande</a>'.$n;
    }

    $out .= '</div>'.$n;
    
    return $out;
}

1;
