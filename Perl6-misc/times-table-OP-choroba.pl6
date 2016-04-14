#!/usr/bin/env perl6

say q:heredoc/END/;
Type in the correct answer,
Hit enter key to continue, if it is not correct
the program will not move on to a new problem,
think about your answer, and try again, when it is
the correct answer, it will tell you,
and give a new problem.
END

while 1 {
  my $random  = 11.rand.Int;
  my $random2 = 11.rand.Int;
  say "$random x $random2";
  my $x = $random * $random2;

  while 1 {
    my $answer = get;
    if ($answer eq $x) {
      say "Great, $answer is correct.";
      say "Hit enter to continue, Ctrl+C to exit.";
      get;
      last;
    }
    else {
      say "Sorry, $x is not correct, please try again.";
    }
  }
}
