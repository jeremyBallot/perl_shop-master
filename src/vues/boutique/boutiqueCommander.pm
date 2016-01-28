#####
#   Formulaire de coordonées client
#####

package boutiqueCommander;

use vue;
use CGI qw/:standard/;

sub make {
    my ($class) = @_;
    my $out = '<div>';

    # Formulaire
    $out .= '<form name="commande" class="pure-form pure-form-stacked" method="POST" action="'.vue->path('commander').'"><fieldset>';
    $out .= '<label for="nom">Nom : </label> <input type="text" name="nom" placeholder="Nom">';
    $out .= '<label for="prenom">Prénom : </label> <input type="text" name="prenom" placeholder="Prénom">';
    $out .= '<label for="civilite">Civilité : </label>';
    $out .= 'M.<input name="civilite" type="radio" value="M." checked>';
    $out .= 'Mme<input name="civilite" type="radio" value="Mme">';
    $out .= '<label for="email">Couriel : </label> <input type="email" name="email" placeholder="Couriel">';
    $out .= '<label for="adresse">Adresse : </label> <textarea name="adresse"></textarea>';
    $out .= '<input type="submit">';
    $out .= '</fieldset></form>';

    return $out . '</div>';
}

1;
