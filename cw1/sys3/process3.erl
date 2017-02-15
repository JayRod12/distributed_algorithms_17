-module(process3).
-export([start/2]).

start(ID, System) ->
  C = spawn(app, start, [ID]),
  PL = spawn(perfect_p2p_links, start, []), 
  System ! {pl_discover, PL},
  BEB = spawn(best_effort_broadcast, start, [C, PL]),
  C ! {bind, BEB},
  PL ! {bind, BEB}.



