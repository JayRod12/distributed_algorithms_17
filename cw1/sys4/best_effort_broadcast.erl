-module(best_effort_broadcast).
-export([start/2]).

start(C, PL) ->
  receive
    {pl_deliver, {bind, PLs}} ->
      next(C, PL, PLs)
  end.


next(C, PL, PLs) ->
  receive
    {beb_broadcast, M} ->
      [PL ! {pl_send, Dest, M} || Dest <- PLs];
    {pl_deliver, M} ->
      C ! {beb_deliver, M}
  end,
  next(C, PL, PLs).



