% Find

% 1. Prolog has some input/output features as well. Find print predicates that
%    print out variables.

% write_term/3, write_term/2
% write/1, write/2
% writeq/1, writeq/2
% write_canonical/1, write_canonical/2
%
% See documentation here: http://www.swi-prolog.org/pldoc/man?section=termrw

% 2. Find a way to use the print predicates to print only successful solutions.
%    How do they work?

% Make sure that printing solutions only happens after solutions are known?
% Not sure if I understood the question.

% Do

% 1. Modify the Sudoku solver to work on six-by-six puzzles (squares are 3x2)
%    and 9x9 puzzles.

% 2. Make the Sudoku solver print prettier solutions.

% 3. Solve the Eight Queens problem by taking a list of queens. Rather than a
%    tuple, represent each queen with an integer, from 1--8. Get the row of a
%    queen by its position in the list and the column by the value in the list.

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
