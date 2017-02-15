-module(system4).
-export([start/1]).


start(Args) ->
  [N, Max_messages, Timeout] = parse(Args),
  [ spawn(process4, start, [ID, self()]) || ID <- lists:seq(1, N) ],
  PLs = bind_pls(N, []),
  [ PL ! {net_send, {bind, PLs}} || PL <- PLs ],
  M = {task1, start, Max_messages, Timeout, N},
  [ PL ! {net_send, M} || PL <- PLs ].


bind_pls(0, PLs) -> PLs;
bind_pls(N, PLs) ->
  receive
    {pl_discover, PL} ->
      PLs2 = [PL | PLs]
  end,
  bind_pls(N - 1, PLs2).


parse([N_str, M_str, T_str]) ->
  [list_to_integer(N_str), 
   list_to_integer(M_str),
   list_to_integer(T_str)].
