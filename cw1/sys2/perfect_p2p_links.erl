-module(perfect_p2p_links).
-export([start/1]).


start(C) ->
  receive
    {net_send, {bind, PLs}} ->
      next(C, PLs)
  end.

next(C, PLs) ->
  receive
    {pl_send, broadcast, M} ->
      broadcast(M, PLs);
    {net_send, M} ->
      C ! {pl_deliver, M}
  end,
  next(C, PLs).

broadcast(M, PLs) ->
  [PL ! {net_send, M} || PL <- PLs].
    

  
