# Find

1. Prolog has some input/output features as well. Find print predicates that
   print out variables.

    ```Prolog
    % format/2, format/3
    % print/2, print/3
    % write/1, write/2
    % write_canonical/1, write_canonical/2
    % write_term/3, write_term/2
    % writeq/1, writeq/2
    ```

   Details at http://www.swi-prolog.org/pldoc/man?section=termrw.

2. Find a way to use the print predicates to print only successful solutions.
   How do they work?

  Make sure that printing occurs only after all possible solutions are
  generated? (Not sure if I understood the question.)

# Do

1. Modify the Sudoku solver to work on six-by-six puzzles (squares are 3x2) and
   9x9 puzzles.

  I thought making slightly different solvers for distinct sudoku sizes would
  be inelegant, so I've created [sudoku](https://github.com/mpereira/sudoku),
  which solves puzzles of arbitrary dimensions.

  ### Installing [sudoku](https://github.com/mpereira/sudoku)
    ```Bash
    $ git clone https://github.com/mpereira/sudoku.git
    $ cd sudoku
    $ make
    $ sudo make install
    ```

  ### 6x6 puzzle with 3x2 blocks
    ```Bash
    $ wget https://github.com/mpereira/sudoku/puzzles/6x6_3x2_0.txt
    $ cat 6x6_3x2_0.txt
    . 5 . . . 2
    3 2 . . . .
    . . 4 . . .
    . . . 1 . 5
    2 . 5 . . .
    . 4 . . . .
    $ sudoku 6x6_3x2_0.txt
    4 5|1 3|6 2
    3 2|6 5|1 4
    1 6|4 2|5 3
    ---+---+---
    6 3|2 1|4 5
    2 1|5 4|3 6
    5 4|3 6|2 1
    ```

  ### 9x9 puzzle
    ```Bash
    $ wget https://github.com/mpereira/sudoku/puzzles/9x9_0.txt
    $ cat 9x9_0.txt
    8 5 . . . 2 4 . .
    7 2 . . . . . . 9
    . . 4 . . . . . .
    . . . 1 . 7 . . 2
    3 . 5 . . . 9 . .
    . 4 . . . . . . .
    . . . . 8 . . 7 .
    . 1 7 . . . . . .
    . . . . 3 6 . 4 .
    $ sudoku 9x9_0.txt
    8 5 9|6 1 2|4 3 7
    7 2 3|8 5 4|1 6 9
    1 6 4|3 7 9|5 2 8
    -----+-----+-----
    9 8 6|1 4 7|3 5 2
    3 7 5|2 6 8|9 1 4
    2 4 1|5 9 3|7 8 6
    -----+-----+-----
    4 3 2|9 8 1|6 7 5
    6 1 7|4 2 5|8 9 3
    5 9 8|7 3 6|2 4 1
    ```

2. Make the Sudoku solver print prettier solutions.

  [sudoku](https://github.com/mpereira/sudoku) prints pretty solutions.

3. Solve the Eight Queens problem by taking a list of queens. Rather than a
   tuple, represent each queen with an integer, from 1--8. Get the row of a
   queen by its position in the list and the column by the value in the list.

    ```Prolog
    :- use_module(library(clpfd)).

    diagonal_operation(sw_ne, D, R, C) :- D is R - C.
    diagonal_operation(nw_se, D, R, C) :- D is R + C.

    distinct_diagonal(DT, Qs) :- distinct_diagonal(DT, Qs, 1, []).
    distinct_diagonal(_, [], _, Ds) :- all_distinct(Ds).
    distinct_diagonal(DT, [C | Qs], R, Ds) :-
      diagonal_operation(DT, D, R, C),
      R1 is R + 1,
      distinct_diagonal(DT, Qs, R1, [D | Ds]).

    mapmember(L, E) :- member(E, L).

    eight_queens(Qs) :-
      length(Qs, 8),
      maplist(mapmember([1, 2, 3, 4, 5, 6, 7, 8]), Qs),
      all_distinct(Qs),
      distinct_diagonal(sw_ne, Qs),
      distinct_diagonal(nw_se, Qs).
    ```
