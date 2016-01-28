#!/usr/bin/env perl

use strict;

my $num = 'coucou';

if ($num =~ /^\d+$/) {
	print 'integer';
    }
if ($num =~ /^[a-z]+$/) {
	print 'string';
    }
