-module(aoc3).

-export([solve/0]).


solve() ->
    Input = input(),
    Map = prepare_map(Input),
    R1 = solve_1(Map),
    R2 = solve_2(Map),
    io:format(user, "Result 1: ~p~n", [R1]),
    io:format(user, "Result 2: ~p~n", [R2]).


solve_1(Map) ->
    solve(Map, [{3,1}]).

solve_2(Map) ->
    solve(Map, [{1,1}, {3,1}, {5,1}, {7,1}, {1,2}]).

solve(Map, Sequences) ->
    lists:foldl(fun({XSteps, YSteps}, Acc) ->
                        A = solve(Map, XSteps, YSteps),
                        io:format("~p ~p ~p~n", [XSteps, YSteps, A]),
                        Acc * A
                end, 1, Sequences).

solve(Map, XSteps, YSteps) ->
    Sequence = lists:foldl(fun(_, [{X, Y}|_] = Acc) ->
                                   [{X + XSteps, Y + YSteps}|Acc]
                           end, [{1,1}], lists:droplast(Map)),
    lists:foldl(fun({X, Y}, Acc) ->
                        case map_element(Map, X, Y) of
                            $# ->
                                Acc + 1;
                            $. ->
                                Acc
                        end
                end, 0, Sequence).

map_element(Map, X, Y) ->
    try
        lists:nth(X, lists:nth(Y, Map))
    catch
        _:_ ->
            $.
    end.

input() ->
    {ok, Binary} = file:read_file("input3.txt"),
    Rows = binary:split(Binary, <<"\n">>, [global]),
    [ binary_to_list(Row) || Row <- Rows, Row /= <<>> ].

prepare_map(Input) ->
    NoOfRows = length(Input),
    MinWidth = 7 * NoOfRows,
    [ append_map(Row, MinWidth, []) || Row <- Input ].

append_map(_Row, MinWidht, MapRow) when length(MapRow) > MinWidht ->
    MapRow;
append_map(Row, MinWidth, MapRow) ->
    append_map(Row, MinWidth, MapRow ++ Row).
