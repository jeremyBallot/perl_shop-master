#!/usr/bin/env perl

use strict;
use lib ("../src/vues/boutique");
use lib ("../src/vues");
use lib ("../src/modeles");
use lib ("../src/controllers");

use layout;

print layout->make("bonsoir");
