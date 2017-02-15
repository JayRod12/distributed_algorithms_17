-module(process6).
-export([start/2]).

start(ID, System) ->
  C = spawn(app, start, [ID]),
  Rel = rand:uniform(100),
  io:format("Process ~p has ~p% reliability ~n", [ID, Rel]),
  PL = spawn(lossy_p2p_links, start, [Rel]), 
  System ! {pl_discover, PL},
  BEB = spawn(best_effort_broadcast, start, [PL]),
  RB = spawn(eager_reliable_broadcast, start, [C, BEB]),
  C ! {bind, RB},
  BEB ! {bind, RB},
  PL ! {bind, BEB}.
