-module(system1).
-export([start/1]).


start(Args) ->
  [N, Max_messages, Timeout] = parse(Args),
  PS = lists:map(fun(ID) -> {ID, spawn(process1, start, [ID])} end, lists:seq(1, N)),

  [P ! {bind, self(), PS} || {_, P} <- PS],
  M             = {task1, start, Max_messages, Timeout},
  [P ! M || {_, P} <- PS].

parse([N_str, M_str, T_str]) ->
  [list_to_integer(N_str), 
   list_to_integer(M_str),
   list_to_integer(T_str)].
