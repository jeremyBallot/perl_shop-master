#!/usr/bin/env perl

use strict;

use lib ("../src/modeles");

use Categorie;
use Produit;
use ProdCom;
use Individu;
use Client;
use Admin;
use Commande;

Individu->createTable();
Client->createTable();
Admin->createTable();
Categorie->createTable();
Produit->createTable();
Commande->createTable();
ProdCom->createTable();




print "\n### CLIENTS ###\n";
my $cli0 = Client->new('John', 'Doe', 'john.doe@email.com', 'pass', 'Dijon', '15/05/1658', 'Mr');
print $cli0->toString() ."\n";
$cli0->store();
my $cli1 = Client->new(0);
$cli1->{nom} = 'Chuck';
$cli1->store();
my $cli2 = Client->new(0);
print $cli2->toString() ."\n";

print "\n### ADMIN ###\n";
my $adm0 = Admin->new('DUPIN', 'Jérémi', 'jeremi.dupin@gmail.com', 'mdp', 'super');
print $adm0->toString() ."\n";
$adm0->store();
my $adm1 = Admin->new(1);
$adm1->{nom} = 'Dupin';
$adm1->store();
my $adm2 = Admin->new(1);
print $adm2->toString() . "\n";

print "\n### CATEGORIE ###\n";
my $cat0 = Categorie->new('Informatique', -1);
print $cat0->toString() ."\n";
$cat0->store();
my $cat1 = Categorie->new(0);
$cat1->{nom} = 'Electronique';
$cat1->store();
my $cat2 = Categorie->new(0);
print $cat2->toString() ."\n";

print "\n### PRODUIT ###\n";
my $prod0 = Produit->new('Ordinateur portable', 'Entrée de gamme', 0, 490.99, 'uriphoto', 6);
print $prod0->toString() ."\n";
$prod0->store();
my $prod1 = Produit->new(0);
$prod1->{prix} = 680.60;
$prod1->store();
my $prod2 = Produit->new(0);
print $prod2->toString() ."\n";

print "\n### COMMANDES ###\n";
my $com0 = Commande->new(0, '15/02/2015', '17/02/2015');
print $com0->toString() ."\n";
$com0->store();
my $com1 = Commande->new(0);
$com1->{dateP} = '15/02/2015';
$com1->store();
my $com2 = Commande->new(0);
print $com2->toString() ."\n";
Commande->remove(0);

print "\n### PRODUIT COMMANDE ###\n";
my $pc0 = ProdCom->new(0, 0, 2);
print $pc0->toString() ."\n";
$pc0->store();
my $pc1 = ProdCom->new(0);
$pc1->{quantitee} = 1;
$pc1->store();
my $pc2 = ProdCom->new(0);
print $pc2->toString() ."\n";
