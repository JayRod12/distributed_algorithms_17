-module(system6).
-export([start/1]).


start(Args) ->
  [N, Max_messages, Timeout, Kill, KillTimeout] = parse(Args),
  [ spawn(process6, start, [ID, self()]) || ID <- lists:seq(1, N) ],
  PLs = bind_pls(N, []),
  [ PL ! {net_send, {bind, PLs}} || PL <- PLs ],
  M = {task1, start, Max_messages, Timeout, N},
  [ PL ! {net_send, M} || PL <- PLs ],
  if
    Kill =/= 0->
      timer:send_after(KillTimeout, lists:nth(Kill, PLs), terminate);
    true -> ok
  end.

  


bind_pls(0, PLs) -> PLs;
bind_pls(N, PLs) ->
  receive
    {pl_discover, PL} ->
      PLs2 = [PL | PLs]
  end,
  bind_pls(N - 1, PLs2).


parse([N_str, M_str, T_str, Kill, KillTimeout]) ->
  [list_to_integer(N_str), 
   list_to_integer(M_str),
   list_to_integer(T_str),
   list_to_integer(Kill),
   list_to_integer(KillTimeout)].
