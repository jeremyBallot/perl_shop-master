package Controller;

use strict;
use CGI;

use layout;

my $path = "./";

# Constructeur
sub new {
    my($class, $title) = @_;
    my $this = {};
    $this->{title} = $title;
    $this->{cgi} = new CGI();
    $this->{cookie} = '';
    $this->{css} = '';
    bless($this, $class);
    return $this;
}

# Méthode de rendu globale
sub render {
    my ($this, $content) = @_;
    
    # Récupération des catégories
    my @cats = Categorie->getCategories();
    
    # Response
    print $this->{cgi}->header(-type=>'text/html', -charset=>'utf-8', -status=>'200 Ok', -cookie=>$this->{cookie});
    
    # Appel du layout général
    print layout->make(
	'content' =>$content, 
	'cats' => \@cats, 
	'css' => $this->{css}
    );
}

# Méthode de redirection
sub redirect {
    my ($this, $url) = @_;
    print $this->{cgi}->redirect(-uri=>$url, -status=>'303 See Other', -cookie=>$this->{cookie});
}

# Page d'erreur 404
sub notFound {
    my ($this) = @_;
    print $this->{cgi}->header(-type=>'text/html', -charset=>'utf-8', -status=>'404 Not Found');
    print layout->make('<h2>Page introuvable !</h2>');
}

# Génère les URL
sub path {
    my ($class, $way) = @_;
    return 'http://'.$ENV{'HTTP_HOST'}.'/perlshop/'.$way;
}

# Affecte un cookie
sub setCookie {
    my ($this, $cookie) = @_;
    $this->{cookie} = $cookie;
}

# Affecte un style
sub setCSS {
    my ($this, $css) = @_;
    $this->{css} = $css;
}

1;
