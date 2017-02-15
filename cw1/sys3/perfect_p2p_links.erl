-module(perfect_p2p_links).
-export([start/0]).


start() ->
  receive
    {bind, BEB} -> 
      next(BEB)
  end.

next(BEB) ->
  receive
    {pl_send, Dest, M} ->
      Dest ! {net_send, M};
    {net_send, M} ->
      BEB ! {pl_deliver, M}
  end,
  next(BEB).

