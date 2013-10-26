# Find

1. An OTP service that will restart a process if it dies

  https://github.com/basho/riak_core/blob/develop/src/riak_core_sup.erl

2. Documentation for building a simple OTP server

- http://www.erlang.org/doc/design_principles/des_princ.html
- http://learnyousomeerlang.com/building-applications-with-otp

# Do

**Observation**: I'm assuming that the author means *supervisor* when the word
*monitor* is used, since *monitors* were not covered in this book. These words
have similar but different meanings in Erlang.

1. Monitor the `translate_service` and restart it should it die.

  `translate_service.erl`

    ```Erlang
    -module(translate_service).
    -export([start_link/0, init/0, translate/2]).

    start_link() ->
      io:format("starting translate_service~n"),
      spawn_link(?MODULE, init, []).

    init() ->
      loop().

    loop() ->
      receive
        {From, "casa"}   -> From ! "house";
        {From, "blanca"} -> From ! "white";
        {From, _}        -> From ! "I don't understand."
      end,
      loop().

    translate(To, Word) ->
      To ! {self(), Word},
      receive
        Translation -> Translation
      end.
    ```

  `translate_service_sup.erl`

    ```Erlang
    -module(translate_service_sup).
    -export([start/0, init/0]).

    start() ->
      io:format("starting translate_service_sup~n"),
      spawn(?MODULE, init, []).

    init() ->
      process_flag(trap_exit, true),
      loop().

    loop() ->
      register(translate_service, translate_service:start_link()),
      receive
        {'EXIT', From, Reason} ->
          io:format("translate_service ~p died: ~p~n", [From, Reason]),
          loop()
      end.
    ```

2. Make the `Doctor` process restart itself if it should die.

  **Observation**: to my understanding, a process can't restart itself reliably
  in Erlang, so I'm assuming the author misused the word *itself*.

  `revolver.erl`

    ```Erlang
    -module(revolver).
    -export([start_link/0, init/0]).

    start_link() ->
      io:format("starting revolver~n"),
      spawn_link(?MODULE, init, []).

    init() ->
      loop().

    loop() ->
      receive
        3 ->
          io:format("bang~n"),
          exit(shot_fired);
        _ ->
          io:format("click~n"),
          loop()
      end.
    ```

  `doctor.erl`

    ```Erlang
    -module(doctor).
    -export([start_link/0, init/0]).

    start_link() ->
      io:format("starting doctor~n"),
      spawn_link(?MODULE, init, []).

    init() ->
      process_flag(trap_exit, true),
      loop().

    loop() ->
      register(revolver, revolver:start_link()),
      receive
        {'EXIT', From, Reason} ->
          io:format("revolver ~p died: ~p~n", [From, Reason]),
          loop()
      end.
    ```

  `doctor_sup.erl`

    ```Erlang
    -module(doctor_sup).
    -export([start/0, init/0]).

    start() ->
      io:format("starting doctor_sup~n"),
      spawn(?MODULE, init, []).

    init() ->
      process_flag(trap_exit, true),
      loop().

    loop() ->
      register(doctor, doctor:start_link()),
      receive
        {'EXIT', From, Reason} ->
          io:format("doctor ~p died: ~p~n", [From, Reason]),
          loop()
      end.
    ```

3. Make a monitor for the `Doctor` monitor. If either monitor dies, restart it.

  Essentially the same answer as #2.

4. (Bonus) Create a basic OTP server that logs messages to a file.

    ```Erlang
    -module(logger).
    -behaviour(gen_server).

    -export([start_link/0, log/1]).
    -export([
             init/1,
             handle_call/3,
             handle_cast/2,
             handle_info/2,
             terminate/2,
             code_change/3
            ]).

    -define(SERVER, ?MODULE).
    -define(FILE_NAME, "logger.log").

    -record(state, {}).

    start_link() ->
      gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

    init([]) ->
      {ok, #state{}}.

    handle_call({log, String}, _From, State) ->
      case file:open(?FILE_NAME, [append]) of
        {ok, IO} ->
          io:fwrite(IO, lists:concat([timestamp(), " ", String, "~n"]), []),
          {reply, ok, State};
        {error, Reason} ->
          {reply, {error, Reason}, State}
      end.

    handle_cast(_Msg, State) ->
      {noreply, State}.

    handle_info(_Info, State) ->
      {noreply, State}.

    terminate(_Reason, _State) ->
      ok.

    code_change(_OldVersion, State, _Extra) ->
      {ok, State}.

    log(String) ->
      gen_server:call(?SERVER, {log, String}).

    timestamp() ->
      {{Year, Month, Day}, {Hour, Minute, Second}} = erlang:universaltime(),
      io_lib:format("[~4..0w-~2..0w-~2..0wT~2..0w:~2..0w:~2..0w+00:00]",
                    [Year, Month, Day, Hour, Minute, Second]).
    ```

5. (Bonus) Make the `translate_service` work across a network.

  **Observation**: Accomplished with
  [distributed Erlang](http://www.erlang.org/doc/reference_manual/distributed.html).

  `translate_service.erl`

    ```Erlang
    -module(translate_service).
    -export([start/1, init/0, translate/2]).

    start(Node) ->
      io:format("starting translate_service~n"),
      spawn(Node, ?MODULE, init, []).

    init() ->
      loop().

    loop() ->
      receive
        {From, "casa"}   -> From ! "house";
        {From, "blanca"} -> From ! "white";
        {From, _}        -> From ! "I don't understand."
      end,
      loop().

    translate(To, Word) ->
      To ! {self(), Word},
      receive
        Translation -> Translation
      end.
    ```

  `Server node (IPv4 address: 172.16.254.1, hostname: saturn)`

    ```Bash
    $ echo '0.0.0.0 saturn' | sudo tee -a /etc/hosts
    $ echo '172.16.233.3 titan' | sudo tee -a /etc/hosts
    $ erl -sname server -setcookie b8fcd774-eb05-469a-8cb5-a0d422950026
    (server@saturn)> c(translate_service).
    {ok,translate_service}
    ```
  `Client node (IPv4 address: 172.16.233.3, hostname: titan)`

    ```Bash
    $ echo '172.16.254.1 saturn' | sudo tee -a /etc/hosts
    $ echo '0.0.0.0 titan' | sudo tee -a /etc/hosts
    $ erl -sname client -setcookie b8fcd774-eb05-469a-8cb5-a0d422950026
    (client@titan)> c(translate_service).
    {ok,translate_service}
    (client@titan)> TranslateService = translate_service:start(server@saturn).
    starting translate_service
    <9186.51.0>
    (client@titan)> translate_service:translate(TranslateService, "casa").
    "house"
    ```
