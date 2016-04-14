#!/usr/bin/env perl6

# [BrowserUK]'s solution to this problem in Perl 5 took < 1 sec:
#
# (44,289! 11,800!) (10,389! 45,700!)
# -----------------------------------
# 56,089! 989! 9,400! 43,300! 11,800! 2,400!

# trying with Perl 6

# BrowserUK's problem he solve in
# from rosettacode.org (Larry Wall):
#   via Memoized Constant Sequence[edit]
#     This approach is much more efficient for repeated use, since it
#     automatically caches. [\*] is the so-called triangular version of
#     [*]. It returns the intermediate results as a list. Note that Perl 6
#     allows you to define constants lazily, which is rather helpful when
#     your constant is of infinite size...
#
#       constant fact = 1, |[\*] 1..*;
#       say fact[5];

#constant fact = 1, |[\*] 1..*;

# numerator
#   = fact[44289] * fact[11800] * fact[1039] * fact[45700]
# denominator
#   = fact[56089] * fact[989] * fact[9400] * fact[43300] * fact[11800] * fact[2400]

# generate an arbitrary precision rational number:
#my $c = FatRat.new(fact[44289] * fact[11800] * fact[1039] * fact[45700],
#                   fact[56089] * fact[989] * fact[9400] * fact[43300] * fact[11800] * fact[2400]);

my $c = FatRat.new(factorial(44289) * factorial(11800) * factorial(1039) * factorial(45700),
                   factorial(56089) * factorial(989) * factorial(9400) * factorial(43300) * factorial(11800) * factorial(2400));

#my $c = FatRat.new(factorial(44) * factorial(100) * factorial(100) * factorial(1000),
#                   factorial(56) * factorial(200) * factorial(200) * factorial(300) * factorial(2000));

say "Real \$c: $c";
say "Rational \$c: { $c.numerator } / { $c.denominator }";

##### subroutines #####
use experimental :cached;
constant fact = 1, |[\*] 1..*;
sub factorial(Int:D $x where * > -1) is cached {
  return fact[$x];
}
