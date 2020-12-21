-module(aoc2).

-export([solve/0]).


solve() ->
    Input = input(),
    R1 = solve_1(Input),
    R2 = solve_2(Input),
    io:format(user, "Result 1: ~p~n", [R1]),
    io:format(user, "Result 2: ~p~n", [R2]).


solve(Input, Filter) ->
    length(lists:filter(Filter, Input)).

solve_1(Input) ->
    solve(Input, fun filter_1/1).

solve_2(Input) ->
    solve(Input, fun filter_2/1).


filter_1({Min, Max, Letter, Password}) ->
    Occurances = length([ X || X <- Password, X == Letter ]),
    Min =< Occurances andalso Max >= Occurances.

filter_2({First, Second, Letter, Password}) ->
    One = lists:nth(First, Password),
    Two = lists:nth(Second, Password),
    One /= Two andalso (One == Letter orelse
                        Two == Letter).

input() ->
    {ok, Binary} = file:read_file("input2.txt"),
    Rows = binary:split(Binary, <<"\n">>, [global]),
    [ parse_row(Row) || Row <- Rows, Row /= <<>> ].

parse_row(Row) ->
    [Interval, LetterAndSeparator, RawPassword] = binary:split(Row, <<" ">>, [global]),
    [Min, Max] = binary:split(Interval, <<"-">>),
    [LetterString, <<>>] = binary:split(LetterAndSeparator, <<":">>),
    [Letter] = binary_to_list(LetterString),
    Password = string:trim(binary_to_list(RawPassword)),
    {binary_to_integer(Min), binary_to_integer(Max), Letter, Password}.
