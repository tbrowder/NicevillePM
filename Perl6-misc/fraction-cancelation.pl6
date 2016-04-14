#!/usr/bin/env perl6

my @a = <1 4 6 2 7 87 5 6 4 32>;
my @b = <86 50 62 41 32>;

my $a = [*] @a;
my $b = [*] @b;

say "product of array \@a = $a";
say "product of array \@b = $b";

# generate an arbitrary precision rational number:
my $c = FatRat.new($a, $b);
say "Real \$c: $c";
say "Rational \$c: { $c.numerator } / { $c.denominator }";
