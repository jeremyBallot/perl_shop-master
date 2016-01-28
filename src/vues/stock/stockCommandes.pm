######
#   Liste des commandes
#
#   Ce fichier liste les commandes
######

package stockCommandes;

use vue;
use CGI qw/:standard/;

sub make {
    my ($class, %args) = @_;
    my $n = "\n";
    my $t = "\t";
    my $out = '<div>'.$n;

    $out .= $t.'<h1>'.$args{titre}.'</h1>'.$n;

    $out .= '<table class="pure-table pure-table-bordered pure-table-striped">'.$n;
    $out .= $t.'<thead><tr>'.$n;
    $out .= $t.$t.'<th>Ref.</th><th>Num. client</th><th>Date commande</th><th>Date paiment</th><th>Date envoi</th>'.$n;
    $out .= $t.'</tr></thead>'.$n;
    $out .= $t.'<tbody>'.$n;
    foreach (@{$args{commandes}->{commandes}}) {
	$out .= $t.$t.'<tr>'.$n;
	$out .= $t.$t.$t.'<td><a href="'.vue->path('stock/commande/'.$_->{id}).'">'.$_->{id}.'</a></td>'.$n;
	$out .= $t.$t.$t.'<td>'.$_->{client}.'</td>'.$n;
	$out .= $t.$t.$t.'<td>'.$_->{dateC}.'</td>'.$n;
	$out .= $t.$t.$t.'<td>'.$_->{dateP}.'</td>'.$n;
	$out .= $t.$t.$t.'<td>'.$_->{dateE}.'</td>'.$n;
	$out .= $t.$t.'</tr>'.$n;
    }
    $out .= $t.'</tbody>'.$n;
    $out .= '</table>'.$n;

    $out .= '</div>';

    return $out;
}

1;
