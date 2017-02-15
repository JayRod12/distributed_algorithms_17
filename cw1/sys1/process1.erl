-module(process1).
-export([start/1]).

start(ID) ->
  receive
    {bind, _, NS} -> listen(ID, NS)
  end.

listen(ID, NS) ->
  receive
    {task1, start, Max_messages, Timeout} ->
      next(ID, Max_messages, Timeout, NS)
  end.

next(ID, Max, Timeout, NS) ->
  % Map where each neighbor N has a tuple with the count of messages
  % {TO N (from this process), FROM N (to this process)}
  Map = maps:from_list(lists:map(fun({N, _}) -> {N, {0, 0}} end, NS)),
  timer:send_after(Timeout, self(), timeout),
  sendOrReceive(ID, 0, Max, Map, NS).
  
sendOrReceive(ID, N, Max, Map, NS) ->
  receive
    {message, OtherID} ->
      {To, From} = maps:get(OtherID, Map),
      Map2 = maps:update(OtherID, {To, From + 1}, Map),
      sendOrReceive(ID, N, Max, Map2, NS);
    timeout ->
      display_map(ID, Map)
  after
    0 -> % No messages in queue
      broadcast(ID, N, Max, Map, NS)
  end.

broadcast(ID, N, Max, Map, NS) ->
  case N < Max orelse Max =:= 0 of
    true ->
      [TIDN ! {message, ID} || {_, TIDN} <- NS],
      Map2 = updateMap(Map),
      N2 = N + 1;
    false ->
      Map2 = Map,
      N2 = N
  end,
  sendOrReceive(ID, N2, Max, Map2, NS).

updateMap(Map) ->
  maps:map(fun(_, {To, From}) -> {To + 1, From} end, Map).

%broadcast(ID, NumMsg, Map, NS) ->
%  if
%    % run out of messages
%    NumMsg == -1 ->
%      sendOrReceive(ID, NumMsg, Map, NS);
%    true ->
%      if
%        % send indefinitely
%        NumMsg == 0 ->
%          Next = 0;
%        % last message
%        NumMsg == 1 ->
%          Next = -1;
%        % decrease number of left messages
%        true ->
%          Next = NumMsg - 1
%      end,
%      [TIDN ! {message, ID} || {_, TIDN} <- NS],
%      Map2 = maps:map(fun(_, {To, From}) -> {To + 1, From} end, Map),
%      sendOrReceive(ID, Next, Map2, NS)
%  end.

display_map(ID, Map) ->
  Out = string:join(lists:map(
    fun(V) ->
      F = io_lib:format("~p", [V]),
      lists:flatten(F)
    end, maps:values(Map)), " "),
  io:format("~p: ~s~n", [ID, Out]).
