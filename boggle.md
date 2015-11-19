# This program:
Generates a new Boggle puzzle, then in about one and a half minute look for words from length 3 to 7 and calculate the points.

Its output is the total point only, for now. More detailed output coming soon.

# Boggle Solver challenge
https://gist.github.com/scottburton11/a2d8afcee57d13232ed4

[Boggle](http://en.wikipedia.org/wiki/Boggle) is a word game played with
alphabetic letter tiles arranged randomly on a grid. Players must identify
words spelled by sequential adjacent letters in any direction
(horizontally, vertically or diagonally), but may not use the same
letter tile twice.

## Challenge

Write a program that solves a 4x4 randomly arranged Boggle grid.

## Going Further

* What external resources would help?
* What factors impact performance? What would you do to improve them?
* What are the key data structures in use here? What makes them more
  appropriate than alternatives?
* Can your solution handle words that occur within other words? i.e.
  'catcher' -> ['cat', 'catch', 'her']

## Dictionary source:
https://raw.githubusercontent.com/atebits/Words/master/Words/en.txt