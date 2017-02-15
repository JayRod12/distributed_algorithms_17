-module(best_effort_broadcast).
-export([start/1]).

start(PL) ->
  receive
    % Message sent by system through PL with all PLs
    {pl_deliver, {bind, PLs}} ->
      start(PL, PLs)
  end.

start(PL, PLs) ->
  receive
    {bind, RB} ->
      next(PL, PLs, RB)
  end.


next(PL, PLs, RB) ->
  receive
    {beb_broadcast, M} ->
      [PL ! {pl_send, Dest, M} || Dest <- PLs];
    {pl_deliver, M} ->
      RB ! {beb_deliver, M}
  end,
  next(PL, PLs, RB).



