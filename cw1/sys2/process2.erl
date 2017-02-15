-module(process2).
-export([start/2]).

start(ID, System) ->
  C = spawn(app, start, [ID]),
  PL = spawn(perfect_p2p_links, start, [C]), 
  System ! {pl_discover, PL},
  C ! {pl_bind, PL}.

