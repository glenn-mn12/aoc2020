-module(aoc5).

-export([solve/0]).


solve() ->
    Input = input(),
    R1 = solve_1(Input),
    R2 = solve_2(Input, R1),
    io:format(user, "Result 1: ~p~n", [R1]),
    io:format(user, "Result 2: ~p~n", [R2]).


solve_1(Input) ->
    lists:max([ calc_seat_number(Row) || Row <- Input ]).

calc_seat_number(Seat) ->
    {Row, Column} = parse_seat(Seat),
    8 * Row + Column.

parse_seat(Seat) ->
    String = binary_to_list(Seat),
    RowString = string:left(String, 7),
    ColumnString = string:right(String, 3),
    Row = binary_space($B, $F, {0, 127}, RowString),
    Column = binary_space($R, $L, {0, 7}, ColumnString),
    {Row, Column}.

binary_space(Lower, Upper, Interval, String) ->
    {Result, Result} = lists:foldl(fun(L, {Min, Max}) when L =:= Lower ->
                                           Int = Max - Min,
                                           {1 + Min + Int div 2, Max};
                                      (U, {Min, Max}) when U =:= Upper ->
                                           Int = Max - Min,
                                           {Min, Min + Int div 2}
                                   end, Interval, String),
    Result.

solve_2(Input, MaxSeat) ->
    Occupied = [ calc_seat_number(Row) || Row <- Input ],
    Available = lists:seq(0, MaxSeat),
    Free = [ X || X <- Available, not lists:member(X, Occupied) ],
    [MySeat] = lists:filter(fun(X) ->
                                    not(lists:member(X-1, Free) orelse
                                        lists:member(X+1, Free))
                            end, Free),
    MySeat.




input() ->
    {ok, Binary} = file:read_file("input5.txt"),
    Parts = binary:split(Binary, <<"\n">>, [global]),
    [X || X <- Parts, X /= <<>>].
