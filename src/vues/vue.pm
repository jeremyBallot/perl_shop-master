#####
#   Fonctions utiles pour les vues
#####

package vue;

use CGI qw/:standard/;


## Génère les URL
sub path {
    my ($class, $way) = @_;
    return 'http://'.$ENV{'HTTP_HOST'}.'/perlshop/'.$way;
}

## Retourne les variables d'environnement
## Ne pas laisser publique, pour débogage uniquement
sub environs {
    my $out = "<ul>";
    foreach my $key (sort keys(%ENV)) {
	$out .= "<li>$key = $ENV{$key}</li>";
    }
    return $out . '</ul>';
}

## Retourne les valeurs GET et POST
## Ne pas laisser publique, pour débogage uniquement
sub getpost {
    my $out = '<ul>';
    for my $key (param()) {
	$out .= '<li>'.$key.' = ' .param($key).'</li>';
    }
    return $out . '</ul>';
}

1;
