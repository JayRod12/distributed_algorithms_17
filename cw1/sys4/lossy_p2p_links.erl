-module(lossy_p2p_links).
-export([start/1]).


start(Rel) ->
  receive
    {bind, BEB} -> 
      next(BEB, Rel)
  end.

next(BEB, Rel) ->
  receive
    {pl_send, Dest, M} ->
      Rand = rand:uniform(100),
      case Rand < Rel of
        true ->
          Dest ! {net_send, M};
        % Message not sent due to unreliable message
        % communication
        false ->
          ok
      end;
    {net_send, M} ->
      BEB ! {pl_deliver, M}
  end,
  next(BEB, Rel).

