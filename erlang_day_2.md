# Do

1. Consider a list of keyword-value tuples, such as `[{erlang, "a functional
   language"}, {ruby, "an OO language"}]`. Write a function that accepts the
   list and a keyword and returns the associated value for the keyword.

    ```Erlang
    tuple_list_find(K, Ts) -> {_, V} = lists:keyfind(K, 1, Ts), V.
    ```

2. Consider a shopping list that looks like `[{item, quantity, price}, ...]`.
   Write a list comprehension that builds a list of `items` of the form `[{item,
   total_price}, ...]`, where `total_price` is  `quantity` times `price`.

    ```Erlang
    [{Item, Quantity * Price} || {Item, Quantity, Price} <- [{meat, 1, 10.00},
                                                             {milk, 2, 3.00},
                                                             {eggs, 12, 0.25}]].
    ```

3. (Bonus) Write a program that reads a tic-tac-toe board presented as a list or
   a tuple of size nine. Return the winner (x or o) if a winner has been
   determined, `cat` if there are no more possible moves, or `no_winner` if no
   player has won yet.

    ```Erlang
    -define(TIC_TAC_TOE_SYMBOLS, [x, o]).
    -define(TIC_TAC_TOE_WIDTH, 3).
    -define(TIC_TAC_TOE_EMPTY_SYMBOL, nil).

    tic_tac_toe_transpose([[] | _]) -> [];
    tic_tac_toe_transpose(LL) ->
      [lists:map(fun hd/1, LL) | tic_tac_toe_transpose(lists:map(fun tl/1, LL))].

    tic_tac_toe_rows([]) -> [];
    tic_tac_toe_rows(Board) ->
      [lists:sublist(Board, ?TIC_TAC_TOE_WIDTH) |
       tic_tac_toe_rows(lists:nthtail(?TIC_TAC_TOE_WIDTH, Board))].

    tic_tac_toe_columns(Board) ->
      tic_tac_toe_transpose(tic_tac_toe_rows(Board)).

    % :(
    tic_tac_toe_diagonals([S00, _,   S02,
                           _,   S11, _,
                           S20, _,   S22]) -> [[S00, S11, S22], [S20, S11, S02]].

    tic_tac_toe_lines(Board) ->
      tic_tac_toe_rows(Board) ++
        tic_tac_toe_columns(Board) ++
        tic_tac_toe_diagonals(Board).

    tic_tac_toe_homovalued_lines(Board) ->
      lists:filter(fun([S | Ss]) -> lists:all(fun(Symbol) -> Symbol =:= S end, Ss) end,
                   tic_tac_toe_lines(Board)).

    tic_tac_toe_validate_symbols(Board) ->
      lists:all(fun(Symbol) ->
                  lists:any(fun(ValidSymbol) -> Symbol =:= ValidSymbol end,
                            ?TIC_TAC_TOE_SYMBOLS ++ [?TIC_TAC_TOE_EMPTY_SYMBOL])
                end, Board).

    tic_tac_toe_validate_length(Board) ->
      length(Board) =:= ?TIC_TAC_TOE_WIDTH * ?TIC_TAC_TOE_WIDTH.

    tic_tac_toe_validate(Board) ->
      tic_tac_toe_validate_symbols(Board) and tic_tac_toe_validate_length(Board).

    tic_tac_toe_all_cells_marked(Board) ->
      lists:all(fun(Symbol) -> Symbol =/= ?TIC_TAC_TOE_EMPTY_SYMBOL end, Board).

    tic_tac_toe_winner(Board) ->
      case tic_tac_toe_validate(Board) of
        true -> case tic_tac_toe_homovalued_lines(Board) of
                  [HomovaluedLine] -> hd(HomovaluedLine);
                  [_ | _] -> invalid_board;
                  [] -> case tic_tac_toe_all_cells_marked(Board) of
                          true -> cat;
                          false -> no_winner
                        end
                end;
        false -> invalid_board
      end.
    ```
