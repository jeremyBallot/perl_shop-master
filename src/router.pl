#!/usr/bin/env perl

use lib ("controllers");
use lib ("modeles");
use lib ("vues");
use lib ("vues/boutique");
use lib ("vues/stock");
use Controller;
use BoutiqueController;
use StockController;

# URI de la requète
my $path = $ENV{'REQUEST_URI'};
$path =~ s/^\/perlshop//; #On enlève le prefixe

if($path =~ s!^/stock!!) {
    stock();
} else {
    boutique();
}

sub boutique {
    my $c = BoutiqueController->new();

    # Page d'index
    if ($path =~ m!^/?$!) { $c->indexAction(); }

    # Parcour d'une catégorie
    elsif ($path =~ m!^/categorie/([a-z]+|\d+)/?$!) { $c->categorieAction($1); }

    # Visualisation d'un produit
    elsif ($path =~ m!^/produit/(\d+)/?$!) { $c->produitAction($1); }

    # Visualisation du panier
    elsif ($path =~ m!^/panier/?$!) { $c->panierAction(); }

    # Ajout d'un produit au panier
    elsif ($path =~ m!^/panier/add/(\d+)/?$!) { $c->addPanierAction($1); }

    # Suppression d'un produit du panier
    elsif ($path =~ m!^/panier/delete/(\d+)/?$!) { $c->deletePanierAction($1); }

    # Passer la commande
    elsif ($path =~ m!^/commander/?$!) { $c->commanderAction(); }

    # Page introuvable
    else { $c->notFound(); }
}

sub stock {
    my $c = StockController->new();

    # Page d'index du stock
    if ($path =~ m!^/?$!) { $c->indexAction(); }

    # Détail d'une commande
    elsif ($path =~ m!^/commande/(\d+)/?$!) { $c->commandeAction($1); }

    # Liste des commandes
    elsif ($path =~ m!^/commande/?$!) { $c->commandesAction(); }

    # Commandes non-traités
    elsif ($path =~ m!^/commande/nospray/?$!) { $c->commandesNosprayAction(); }

    # Commandes envoyés
    elsif ($path =~ m!^/commande/send/?$!) { $c->commandesSendAction(); }

    # Expédition de la commande
    elsif ($path =~ m!^/commande/exp/(\d+)/?$!) { $c->commandeExpAction($1); }

    # Liste des produits
    elsif ($path =~ m!^/produit/?$!) { $c->produitsAction(); }

    # Produits en rupture de stock
    elsif ($path =~ m!^/produit/rupture/?$!) { $c->produitsRuptureAction(); }

    # Nouveau produit
    elsif ($path =~ m!^/produit/new/?$!) { $c->newProduitAction(); }

    # Edition produit
    elsif ($path =~ m!^/produit/edit/(\d+)/?$!) { $c->editProduitAction($1); }

    # Supression d'un produit
    elsif ($path =~ m!^/produit/delete/(\d+)/?$!) { $c->deleteProduitAction($1); }

    # Page introuvable
    else { $c->notFound(); }
}
