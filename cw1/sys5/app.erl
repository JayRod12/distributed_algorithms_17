-module(app).
-export([start/1]).

start(ID) ->
  receive
    {bind, BEB} -> listen(ID, BEB)
  end.

listen(ID, BEB) ->
  receive
    {beb_deliver, {task1, start, Max_messages, Timeout, N}} ->
      next(ID, Max_messages, Timeout, N, BEB)
  end.

next(ID, MaxMsg, Timeout, N, BEB) ->
  % Map where each neighbor N has a tuple with the count of messages
  % {TO N (from this process), FROM N (to this process)}
  Map = maps:from_list([{X, {0, 0}} || X <- lists:seq(1, N)]),
  timer:send_after(Timeout, self(), timeout),
  sendOrReceive(ID, 0, MaxMsg, Map, BEB).
  
sendOrReceive(ID, N, Max, Map, BEB) ->
  receive
    {beb_deliver, {message, OtherID}} ->
      % Map2 = maps:update_with(OtherID, fun({To, From}) -> {To, From + 1} end, Map),
      {To, From} = maps:get(OtherID, Map),
      Map2 = maps:update(OtherID, {To, From + 1}, Map),
      sendOrReceive(ID, N, Max, Map2, BEB);
    timeout ->
      display_map(ID, Map)
  after
    0 -> % No messages in queue
      broadcast(ID, N, Max, Map, BEB)
  end.

broadcast(ID, N, Max, Map, BEB) ->
  case N < Max orelse Max =:= 0 of
    true ->
      BEB ! {beb_broadcast, {message, ID}},
      Map2 = updateMap(Map),
      N2 = N + 1;
    false ->
      Map2 = Map,
      N2 = N
  end,
  sendOrReceive(ID, N2, Max, Map2, BEB).

updateMap(Map) ->
  maps:map(fun(_, {To, From}) -> {To + 1, From} end, Map).

display_map(ID, Map) ->
  Out = string:join(lists:map(
    fun(V) ->
      F = io_lib:format("~p", [V]),
      lists:flatten(F)
    end, maps:values(Map)), " "),
  io:format("~p: ~s~n", [ID, Out]).

