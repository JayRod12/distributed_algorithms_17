-module(process4).
-export([start/2]).

start(ID, System) ->
  C = spawn(app, start, [ID]),
  Rel = rand:uniform(100),
  io:format("Process ~p has ~p% reliability ~n", [ID, Rel]),
  PL = spawn(lossy_p2p_links, start, [Rel]), 
  System ! {pl_discover, PL},
  BEB = spawn(best_effort_broadcast, start, [C, PL]),
  C ! {bind, BEB},
  PL ! {bind, BEB}.



