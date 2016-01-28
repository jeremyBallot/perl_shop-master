package BoutiqueController;

###
#   Controlleur de la boutique
#   S'occupe de toute la partie publique de la boutique
###

use strict;

# Modèles
use Categorie;
use Produit;
use Client;
use ProdCom;
use Commande;

# vues
use boutiqueLayout;
use boutiqueGListe;
use boutiquePListe;
use boutiqueProduit;
use boutiquePanier;
use boutiqueCommander;

# Controlleur
use Controller;
our @ISA = ("Controller");

use POSIX qw(strftime);
use CGI;

# Constructeur
sub new {
    my ($class, $form) = @_;
    my $this = Controller::new('Boutique', $form);
    bless($this, $class);
    return $this;
}

# Méthode de rendu
sub render {
    my ($this, $content) = @_;
    # Insertion du contenu
    # Appel de la méthode render générale
    $this->{css} = '<link rel="stylesheet" href="http://'.$ENV{'HTTP_HOST'}.'/boutique.css">';
    #my $out = boutiqueLayout->make(@cats);
    $this->Controller::render($content);
}

# Index principal
# Subroute: /
sub indexAction {
    my ($this) =@_;
    # Récupération des produits en destockage
    my $destockage = Produit->load_from_cat('Destockage');
    # Les places dans une vue "gros items"
    my $content = boutiqueGListe->make($destockage);
    # Appel du render
    $this->render($content);
}

# Liste des produits d'une catégorie
# Subroute: /categorie/{catId}
# Subroute: /categorie/{nomCat}
sub categorieAction {
    my ($this, $cat) = @_;
    my $content = boutiquePListe->make(
	'produits' => Produit->load_from_cat($cat)
    );
    $this->render($content);
}

# Affiche complètement un produit
# Subroute: /produit/{prodId}
sub produitAction {
    my ($this, $prodId) = @_;
    my $content = boutiqueProduit->make(
	'produit' => Produit->new($prodId)
    );
    $this->render($content);
}

# Passe la commande
# Subroute: /commander
sub commanderAction {
    my ($this) = @_;
    my $cgi = $this->{cgi};

    # Commande confirmé
    if ($this->sendCoords()) {
	# Création du client
	my $client = Client->new($cgi->param("nom"), $cgi->param("prenom"), $cgi->param("email"), 'pass', $cgi->param("adresse"), '2014-01-01', $cgi->param("civilite"));
	$client->store();

	# Création de la commande
	my $today = strftime("%Y-%m-%d", localtime);
	my $commande = Commande->new($client->{id}, $today, '', $today);
	$commande->store();
	
	# Création des produits
	my @panier = $cgi->cookie('panier');
	foreach (@panier) {
	    if ($_ =~ m/(\d+)=(\d+)/) {
		my $prod = ProdCom->new($1, $commande->{id}, $2);
		$prod->store();
		my $produit = Produit->new($1);
		$produit->{quantite} -= $2;
		$produit->store();
	    }
	}

	# Vider le panier
	my @newpanier;
	$this->setCookie(CGI->new()->cookie(-name=>'panier', -value=>\@newpanier));

	# Rediriger
	$this->redirect($this->path(''));
    }

    # Commande non-confirmé. Affiche la page de commande
    elsif ($this->lengthPanier() > 0) {
	my $content = boutiqueCommander->make();
	$this->render($content);
    }
    else {
	$this->redirect($this->path('panier'));
    }
}

# Affiche le panier
# Subroute: /panier
sub panierAction {
    my ($this) = @_;
    my $cgi = $this->{cgi};
    my $produits = Produit->many();

    # Récupération du panier
    my @panier = $cgi->cookie('panier');

    # Fabrication des items
    foreach (@panier) {
	if (m/(\d+)=(\d+)/) {
	    my $produit = Produit->new($1);
	    $produit->{quantite} = $2;
	    $produits->add($produit);
	}
    }

    # Appel de la vue
    my $content = boutiquePanier->make(
	'taille' => $this->lengthPanier(),
	'produits' => $produits
    );
    $this->render($content);
}

# Ajoute un produit au panier
# Subroute: /panier/add/{prodId}
sub addPanierAction {
    my ($this, $prodId) = @_;
    my $cgi = $this->{cgi};
    
    # Récupération du panier déjà existant
    my @panier = $cgi->cookie('panier');
    
    # Récupération de la quantité
    my $qte = $cgi->param('qte');
    if ($qte =~ m/(\d+)/) {
	# Si la quantité est inférieure à 1
	if ($1 < 1) { $this->redirect($this->path('produit/'.$prodId)); }

	# Si le produit existe déjà, ajouter la quantité
	my $pres = 0;
	foreach (@panier) {
	    if (m/(\d+)=(\d+)/ && $1==$prodId) {
		$_ = $prodId.'='.($2+$qte);
		$pres = 1;
	    }
	}

	# Sinon ajout au panier
	if (!$pres) { push(@panier, ''.$prodId .'='. $1); }

	# Affectation du cookie
	$this->setCookie(CGI->new()->cookie(-name=>'panier', -value=>\@panier));
    }

    # Redirection
    $this->redirect($this->path('panier'));
}

# Supprime un produit du panier
# Subroute: /panier/delete/{prodId}
sub deletePanierAction {
    my ($this, $prodId) = @_;
    my $cgi = $this->{cgi};

    # Récupération du panier
    my @panier = $cgi->cookie('panier');
    my @newpanier;

    # Supprime le produit
    foreach (@panier) {
	if (m/(\d+)=(\d+)/) {
	    if ($1 != $prodId) {
		push(@newpanier, $_);
	    }
	}
    }

    # Affecte le cookie
    $this->setCookie(CGI->new()->cookie(-name=>'panier', -value=>\@newpanier));

    # Redirection
    $this->redirect($this->path('panier'));
}


# Retourne le nombre d'articles dans le panier
sub lengthPanier {
    my ($this) = @_;
    my $cgi = $this->{cgi};
    my @panier = $cgi->cookie('panier');
    if (length(@panier) == 1 && $panier[0] !~ m/\d+=\d+/) {
	return 0;
    }
    return length(@panier);
}

# Vérifie si les coordonnées on bien été envoyés
sub sendCoords {
    my ($this) = @_;
    my $cgi = $this->{cgi};

    return ($cgi->param("nom") ne undef) and ($cgi->param("prenom") ne undef) and ($cgi->param("civilite") ne undef) and ($cgi->param("email") ne undef) and ($cgi->param("adresse") ne undef);
}


1;
