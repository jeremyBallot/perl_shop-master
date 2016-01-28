#!/usr/bin/env perl

use strict;

use lib ("../src/modeles");
use Categorie;
use Produit;
use ProdCom;
use Commande;
use Client;
use Admin;


print "### CATEGORIES ###\n";
my $cat0 = Categorie->new('Informatique', -1);
$cat0->store();
my $cat1 = Categorie->new('Electromenager', -1);
$cat1->store();
my $cat2 = Categorie->new('Hi-Fi', -1);
$cat2->store();
my $cat3 = Categorie->new('Domotique', -1);
$cat3->store();
my $cat4 = Categorie->new('Auto', -1);
$cat4->store();
my $cat5 = Categorie->new('Jardin', -1);
$cat5->store();
my $cat6 = Categorie->new('Destockage', -1);
$cat6->store();
my $cats = Categorie->many();
$cats->add($cat0, $cat1, $cat2, $cat3, $cat4, $cat5, $cat6);
print $cats->toString() . "\n";

print "\n### PRODUITS ###\n";
my $prod0 = Produit->new('Ordinateur portable', 'Entrée de gamme', 0, 490, "");
$prod0->store();
my $prod1 = Produit->new('Smartphone', 'Autonomie importante', 0, 300, "");
$prod1->store();
my $prod2 = Produit->new('Caméra wifi', 'Grand angle', 3, 160, "");
$prod2->store();
my $prod3 = Produit->new('Lave linge', 'Très silencieux', 1, 256, "");
$prod3->store();
my $prod4 = Produit->new('Pioche', 'Avec manche en bois', 5, 15, "");
$prod4->store();
my $prods = Produit->many();
$prods->add($prod0, $prod1, $prod2, $prod3, $prod4);
print $prods->toString() . "\n";

print "\n### CLIENTS ###\n";
my $cli0 = Client->new('John', 'Doe', 'john.doe@email.com', 'pass', 'Dijon', '15/05/1658', 'Mr');
$cli0->store();
my $cli1 = Client->new('Norris', 'Chuck', 'chucknorris@email.com', 'hahaha', 'Everywere', '00/18/158', 'Mr');
$cli1->store();
my $clis = Client->many();
$clis->add($cli0, $cli1);
print $clis->toString() . "\n";

print "\n### ADMINS ###\n";
my $adm0 = Admin->new('Jérémi', 'Dupin', 'jeremi.dupin@gmail.com', 'passwd', 'Super');
$adm0->store();
my $adms = Admin->many();
$adms->add($adm0);
print $adms->toString() . "\n";

print "\n### COMMANDES ###\n";
my $com0 = Commande->new(1, '13/04/2014', '14/04/2014', '13/04/2014');
$com0->store();
my $coms = Commande->many();
$coms->add($com0);
print $coms->toString() ."\n";


print "\n### PRODUITS COMMANDES ###\n";
my $pc0 = ProdCom->new(2, 0, 1);
$pc0->store();
my $pc1 = ProdCom->new(4, 0, 3);
$pc1->store();
my $pcs = ProdCom->many();
$pcs->add($pc0, $pc1);
print $pcs->toString() ."\n";
