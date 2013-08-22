# Find

1. Some implementations of a Fibonacci series and factorials. How do they work?

    ```Prolog
    naive_fibonacci(0, 0).
    naive_fibonacci(1, 1).
    naive_fibonacci(N, R) :-
      N2 is N - 2,
      N1 is N - 1,
      naive_fibonacci(N2, R2),
      naive_fibonacci(N1, R1),
      R is R1 + R2.

    tail_recursive_fibonacci(N, R) :- tail_recursive_fibonacci(N, 0, 1, R).
    tail_recursive_fibonacci(0, F2, _, F2).
    tail_recursive_fibonacci(N, F2, F1, R) :-
      Sum is F1 + F2,
      N1 is N - 1,
      tail_recursive_fibonacci(N1, F1, Sum, R).
    ```

2. A real-world community using Prolog. What problems are they solving with it
   today?

  Anne Ogborn reports that The University of Houston Dept. of Health and Human
  Performance off-world development is in SWI-Prolog.
  Source: https://thestrangeloop.com/sessions/real-development-boot-camp-in-swi-prolog

  "Watson was written in mostly Java but also significant chunks of code are
  written C++ and Prolog.".
  Source: http://asmarterplanet.com/blog/2011/02/the-watson-research-team-answers-your-questions.html

  Torbjörn Josefsson about Intologic: "Our end-customers are Ericsson (for
  'building' sales solutions for their telephone switches etc), and some banks
  and insurance companies, whom we supply with the tools to evaluate loan
  applications, make profitability calculations etc.".
  Source: http://stackoverflow.com/a/261360

  A configuration management software written in Prolog called "marelle" was
  also released recently (as of august 2013).
  Link: https://github.com/larsyencken/marelle

3. An implementation of the Towers of Hanoi. How does it work?

    ```Prolog
    write_move(A, B) :-
      write('Moved top disk from '),
      write(A),
      write(' to '),
      write(B),
      nl.

    % Base case: moving 1 disk from origin to destination.
    move(1, Origin, Destination, _) :-
      write_move(Origin, Destination).

    % Inductive step:
    %   1. move all disks but the bigger to the auxiliary rod
    %   2. move the bigger disk to the destination rod
    %   3. move all disks in the auxiliary rod to the destination rod
    %
    % It's clear that step 3 can be reduced to the inductive step: since the
    % bigger disk is already at the destination rod you could rearrange the rods'
    % labels and apply the inductive step to the smaller N - 1 disks with the
    % same number of rods.
    move(N, Origin, Destination, Aux) :-
      N1 is N - 1,
      move(N1, Origin, Aux, Destination),
      move(1, Origin, Destination, Destination),
      move(N1, Aux, Destination, Origin).

    hanoi(N) :- move(N, left, right, center).
    ```

4. What are some of the problems of dealing with "not" expressions? Why do you
   have to be careful with negation in Prolog?

  "Not" expressions in Prolog are implemented using `cut` and `fail` predicates,
  which can result in subsequent predicates being ignored.

  See http://en.wikibooks.org/wiki/Prolog/Cuts_and_Negation for more details.

# Do

1. Reverse the elements of a list.

    ```Prolog
    naive_reverse([], []).
    naive_reverse([Head | Tail], List) :-
      naive_reverse(Tail, ReversedTail), append(ReversedTail, [Head], List).

    tail_recursive_reverse(List, ReversedList) :-
      tail_recursive_reverse(List, ReversedList, []).
    tail_recursive_reverse([], ReversedList, ReversedList).
    tail_recursive_reverse([Head | Tail], FutureReversedList, Accumulator) :-
      tail_recursive_reverse(Tail, FutureReversedList, [Head | Accumulator]).
    ```

2. Find the smallest element of a list.

    ```Prolog
    smallest([Element], Element).
    smallest([Head | Tail], Smallest) :-
      smallest(Tail, TailSmallest),
      Smallest is min(Head, TailSmallest).
    ```

3. Sort the elements of a list.

    ```Prolog
    delete_first([Element | Tail], Element, Tail).
    delete_first([ListHead | ListTail], Element, [ListHead | NewListTail]) :-
      delete_first(ListTail, Element, NewListTail).

    selection_sort(List, SortedList) :- selection_sort(List, SortedList, []).
    selection_sort([], SortedList, SortedList).
    selection_sort(List, FutureSortedList, CurrentSortedList) :-
      smallest(List, Smallest),
      delete_first(List, Smallest, NewList),
      append(CurrentSortedList, [Smallest], NewCurrentSortedList),
      selection_sort(NewList, FutureSortedList, NewCurrentSortedList).
    ```
