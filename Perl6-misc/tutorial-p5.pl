#!/usr/bin/env perl

# file: tutorial-p5.pl

# PRELIMS  ========================
use v5.10;    # features 'say' and 'state'
use strict;
use warnings;



use File::Basename;    # p6: no such module yet
use Data::Dumper;

my $default_infile = 'tutorial-data.txt';
my $prog           = basename $0;

my $debug  = 0;
my $infile = 0;
my $usage  = "$prog: --go | --infile=<data file name>";
$usage    .= ' | --help | ? [--debug[=N]]';

# ARG/OPTION HANDLING ========================
if (!@ARGV) {
  say $usage . "\n";
  exit;
}



foreach my $arg (@ARGV) {
  my $oarg = $arg; # save original for error handling
  my $val  = undef;
  my $idx  = index $arg, q{=};
  if ($idx >= 0) {
    $val = substr $arg, $idx+1;
    $arg = substr $arg, 0, $idx;
  }
  if ($arg eq '-g' || $arg eq '--go') {
    $infile = $default_infile;
  }
  elsif ($arg eq '-i' || $arg eq '--infile') {
    $infile = $val;
  }
  elsif ($arg eq '-d' || $arg eq '--debug') {
    $debug = defined $val ? $val : 1;
  }
  elsif ($arg eq '-h' || $arg eq '--help' || $arg eq q{?}) {
    long_help();
  }
  else {
    die "FATAL:  Unknown argument '$oarg'.\n";
  }
}

# MAIN PROGRAM ========================
die "FATAL:  No such file '$infile'.\n"
  if (! -e $infile);

my %user;
my @keywords = qw(last first job);
my %keywords;
@keywords{@keywords} = ();

parse_data_file($infile, \%user, $debug);

if ($debug) {
  say 'DEBUG:  Dumping user hash after loading:';
  print Dumper(\%user);
}
else {
  say 'Normal end.';
}

#### SUBROUTINES ========================
sub parse_data_file {
  my $fname = shift @_;
  my $href  = shift @_;
  my $debug = shift @_ || 0;

  say "Parsing input file '$fname'...";
  open my $fp, '<', $fname
    or die "$fname: $!";

  my $uid = undef;
  my $linenum = 0;
  while (defined(my $line = <$fp>)) {
    ++$linenum;
    my $err = 0;
    # remove comments
    my $idx = index $line, q{#};
    if ($idx >= 0) {
      $line = substr $line, 0, $idx;
    }
    # skip blank lines
    next if $line !~ /\S/xms;

    # every valid line must have a colon (':')
    # following a key word
    $idx = index $line, q{:};
    if ($idx >= 0) {
      # ensure the key is lower case
      my $k = lc substr $line, 0, $idx;
      # trim ws on both ends
      $k =~ s{\A \s* | \s* \z}{}gxms;

      my $val = substr $line, $idx+1;
      # also needs trimming
      $val =~ s{\A \s* | \s* \z}{}gxms;

      # User attributes
      if ($k eq 'user') {
        $uid = $val;
        die 'FATAL:  $uid not defined.'
          if !defined $uid;
        if ($uid =~ /\D/xms) {
          say 'ERROR:  User ID not an integer.';
          ++$err;
        }
        elsif ($uid <= 0) {
          say 'ERROR:  User ID not an integer > 0.';
          ++$err;
        }
        elsif (exists $href->{$uid}) {
          say 'ERROR:  User ID is not unique.';
          ++$err;
        }
        next;
      }

      # for the following keys, an exception will be
      # thrown if $uid is not defined
      if (!defined $uid) {
        say 'ERROR: User ID is not defined for this user.';
          ++$err;
      }
      elsif ($k eq 'hobbies') {
        $href->{$uid}{hobbies} = [];
        my @h = split q{,}, $val;
        foreach my $h (@h) {
          # trim ws on both ends
          $h =~ s{\A \s* | \s* \z}{}gxms;
          push @{$href->{$uid}{hobbies}}, $h;
        }
      }



      elsif (exists $keywords{$k}) {
        $href->{$uid}{$k} = $val;
      }
      else {
	chomp $line;
        say 'ERROR: Unknown line format:';
	say "  '$line'";
        ++$err;
      }
    }
    else {
      say 'ERROR: Unknown line format.';
      ++$err;
    }
    if ($debug) {
      chomp $line;
      say STDERR "DEBUG: line = '$line'";
    }
    if ($err) {
      chomp $line;
      say "FATAL error in file '$fname' at line $linenum:";
      say "  '$line'";
      exit;
    }
  }
} # parse_data_file

sub long_help {

  say <<"HERE";
Usage (one of the following three):

  $prog --go                      (or '-g')
  $prog --infile=<data file name> (or '-i=')
  $prog --help                    (or '-h' or '?')

The '--go' option uses the default input file:

  $default_infile

Any of the first two options can use the '-d' (or '--debug')
  flag for debugging.
A debug number may be provided with '-d=N' (or '--debug=N').

HERE

  exit;
} # long_help
# EOF ========================
