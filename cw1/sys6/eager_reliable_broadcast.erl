-module(eager_reliable_broadcast).
-export([start/2]).

start(C, BEB) ->
  next(C, BEB, []).


next(C, BEB, Delivered) ->
  receive
    {rb_broadcast, M} ->
      BEB ! {beb_broadcast, M},
      next(C, BEB, Delivered);
    {beb_deliver, M} ->
      case lists:member(M, Delivered) of
        true -> 
          next(C, BEB, Delivered);
        false ->
          C ! {rb_deliver, M},
          BEB ! {beb_broadcast, M},
          next(C, BEB, Delivered ++ [M])
      end
  end.



