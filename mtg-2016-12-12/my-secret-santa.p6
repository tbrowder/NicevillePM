#!/usr/bin/env perl6

# mod of Perl 6 Advent, 2016-12-04: Quantum Secret Santa
#
# See: https://github.com/bduggan/quantum-secret-santa

my @grps = 'comet cupid rudolph', 'dancer prancer', 'donner blitzen';

#my $groups = ( <comet cupid rudolph>, <dancer prancer>, <donner blitzen> );
my $groups = ( [@grps[0].words], [@grps[1].words], [@grps[2].words] );

my $mailer = 'msmtp';
my $sender = 'santa@north.pole';

sub generate-santas($groups) {
    my @santas = $groups.flat;
    my %pairs;
    repeat {
        %pairs = @santas Z=> @santas.permutations.pick;
    } until %pairs.none.kv ⊆ $groups.any;
    return %pairs;
}

sub MAIN(Bool :$test) {
    my %gives-to = generate-santas($groups);

    my %s;
    my $n = 0;
    for @grps -> $g {
	++$n;
	say "Group $n: $g";

	my @g = $g.words;
	for @g -> $gg {
	    %s{$gg} = $n;
	}
	=begin pod
	for $grp -> $r {
	    say "  $r";
	}
	=end pod
    }
    say "=== gifts (none to a member of the same group) =>:";
    for %gives-to.keys.sort -> $santa {
        my $santee = %gives-to<<$santa>>;
        if $test {
            #say "$santa gives to $santee";
	    my $n1 = %s{$santa};
	    my $n2 = %s{$santee};

            say "$santa [$n1] => $santee [$n2]";
            next;
        }
    }
}
