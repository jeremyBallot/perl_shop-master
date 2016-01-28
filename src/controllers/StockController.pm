package StockController;

###
#   Controller du stock
#   Gestion du stock, réappro, commandes
###

use strict;

# Modèles
use Produit;
use Commande;
use ProdCom;
use Client;

# Vues
use stockLayout;
use stockCommandes;
use stockCommande;
use stockProduitForm;
use stockDelete;
use stockProduits;


# Controller
use Controller;
our @ISA = ("Controller");

use POSIX qw(strftime);

# Constructeur
sub new {
    my ($class, $form) = @_;
    my $this = Controller::new('Stocks', $form);
    bless($this, $class);
    return $this;
}

# Méthode de rendu
sub render {
    my ($this, $content) = @_;
    $this->{css} = '<link rel="stylesheet" href="http://'.$ENV{'HTTP_HOST'}.'/stock.css">';
    # Layout Stock
    my $out = stockLayout->make(
	'content' => $content
    );
    $this->Controller::render($out);
}

# Index Stock
# Subroute /stock/
sub indexAction {
    my ($this) = @_;
    my $content = '<p>Coucou !</p>';
    $this->render($content);
}

# Liste des commandes
# Subroute /stock/commande/
sub commandesAction {
    my ($this) = @_;
    my $out = stockCommandes->make(
	'titre' => 'Liste des commandes',
	'commandes' => Commande->get_commandes()
    );
    $this->render($out);
}

# Commandes non-traités
# Subroute: /stock/commande/nospray
sub commandesNosprayAction {
    my ($this) = @_;
    my $out = stockCommandes->make(
	'titre' => 'Commandes non-traités',
	'commandes' => Commande->get_no_spray()
    );
    $this->render($out);
}

# Commandes envoyés
# Subroute: /stock/commande/send
sub commandesSendAction {
    my ($this) = @_;
    my $out = stockCommandes->make(
	'titre' => 'Commandes envoyés',
	'commandes' => Commande->get_send()
    );
    $this->render($out);
}

# Détail commande
# Subroute /stock/commande/{comId}
sub commandeAction {
    my ($this, $idCom) = @_;
    # Récupération des données
    my $commande = Commande->new($idCom);
    my $produits = ProdCom->get_from_com($idCom);
    my $client = Client->new($commande->{client});
    # Appel de la vue
    my $out = stockCommande->make(
	'titre' => 'Détail commande',
	'commande' => $commande,
	'client' => $client,
	'produits' => $produits
    );
    $this->render($out);
}

# Expédition de la commande
sub commandeExpAction {
    my ($this, $idCom) = @_;
    my $commande = Commande->new($idCom);
    $commande->{dateE} = strftime("%Y-%m-%d", localtime);
    $commande->store();
    $this->redirect($this->path('stock/commande/nospray'));
}

# Liste des produits
# Subroute: /stock/produit
sub produitsAction {
    my ($this) = @_;
    my $out = stockProduits->make(
	'titre' => 'Liste des produits',
	'produits' => Produit->get_produits()
    );
    $this->render($out);
}

# Produits en rupture de stock
# Subroute: /stock/produit/rupture
sub produitsRuptureAction {
    my ($this) = @_;
    my $out = stockProduits->make(
	'titre' => 'Produits en rupture de stock',
	'produits' => Produit->get_produits_rupture()
    );
    $this->render($out);
}

# Approvisionne un produit
# Subroute /stock/produit/appro/{prodId}
sub approProduitAction {
    # Pas encore implémenté
}

# Nouveau produit
# Subroute: /stock/produit/new
sub newProduitAction {
    my ($this) = @_;
    my $cgi = $this->{cgi};

    # Produit envoyé
    if ($this->sendProduit()) {
	my $prod = Produit->new($cgi->param('nom'), $cgi->param('desc'), $cgi->param('cat'), $cgi->param('prix'), $cgi->param('photo'), $cgi->param('qte'));
	if ($prod->store() ==1) {
	    $this->redirect($this->path('produit/'.$prod->{id})); # Redirection
	} else {
	    # Si le produit n'est pas valide, on réafiche le formulaire pré-remplis
	    my %cats = Categorie->getCategoriesHash();
	    my $out = stockProduitForm->make(
		'cats' => \%cats,
		'produit' => $prod
	    );
	    $this->render($out);
	}
    }

    # Nouveau produit
    else {
	my %cats = Categorie->getCategoriesHash();
	my $out = stockProduitForm->make(
	    'cats' => \%cats
	);
	$this->render($out);
    }
}

# Edition d'un produit
# Subroute: /stock/produit/edit/{prodId}
sub editProduitAction {
    my ($this, $id) = @_;
    my $cgi = $this->{cgi};

    # Produit envoyé
    if ($this->sendProduit()) {
	my $prod = Produit->new($cgi->param("nom"), $cgi->param("desc"), $cgi->param("cat"), $cgi->param("prix"), $cgi->param("photo"), $cgi->param("qte"));
	    $prod->{id} = $id;
	if ($prod->store() == 1) {
	    $this->redirect($this->path('produit/'.$prod->{id})); # Redirection
	} else {
	    # Si le produit n'est pas valide, on réafiche le formulaire pré-remplis
	    my %cats = Categorie->getCategoriesHash();
	    my $out = stockProduitForm->make(
		'cats' => \%cats,
		'produit' => $prod
	    );
	    $this->render($out);
	}
    }

    # Edition produit
    else {
	my $prod = Produit->new($id);
	my %cats = Categorie->getCategoriesHash();
	my $out = stockProduitForm->make(
	    'cats' => \%cats, 
	    'produit' => $prod
	);
	$this->render($out);
    }
}

# Retirer produit
# Subroute: /stock/produit/delete/{prodId}
sub deleteProduitAction {
    my ($this, $id) = @_;
    my $cgi = $this->{cgi};

    # Confirmé
    if ($cgi->param("confirm") eq "yes") {
	Produit->remove($id);
	$this->redirect($this->path('stock'));
    }

    # Affiche une page de confirmation
    my $out = stockDelete->make(
	'produit' => Produit->new($id)
    );
    $this->render($out);
}


# Regarde si un produit à été envoyé
sub sendProduit {
    my ($this) = @_;
    my $cgi = $this->{cgi};

    return ($cgi->param("nom") ne undef) and ($cgi->param("desc") ne undef) and ($cgi->param("cat") ne undef) and ($cgi->param("prix") ne undef) and ($cgi->param("photo") ne undef) and ($cgi->param("qte") ne undef);
}


1;
