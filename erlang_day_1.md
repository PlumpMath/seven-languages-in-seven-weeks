# Find

1. The Erlang language's official site

  http://www.erlang.org/

2. Official documentation for Erlang's function library

  http://www.erlang.org/doc/apps/stdlib/index.html

3. The documentation for Erlang's OTP library

  http://www.erlang.org/doc/

# Do

1. Write a function that uses recursion to return the number of words in a
   string.

    ```Erlang
    words_count(A, []) -> A;
    words_count(A, [_ | Ws]) -> words_count(A + 1, Ws).
    words_count(S) -> words_count(0, string:tokens(S, " ")).
    ```

2. Write a function that uses recursion to count to ten.

    ```Erlang
    count_to(N, N) -> io:format("~p~n", [N]);
    count_to(N, M) -> io:format("~p~n", [M]), count_to(N, M + 1).
    count_to(N) when N > 0 -> count_to(N, 1).

    count_to_ten() -> count_to(10).
    ```

3. Write a function that uses matching to selectively print "success" or "error:
   message" given input of the form `{error, Message}` or `success`.

    ```Erlang
    matcher({error, Message}) -> io:format("error: ~s~n", [Message]);
    matcher(success) -> io:format("success~n").
    ```
