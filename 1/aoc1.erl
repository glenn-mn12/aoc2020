-module(aoc1).

-export([solve/0]).


solve() ->
    Input = input(),
    R1 = solve_1(Input),
    R2 = solve_2(Input),
    io:format(user, "Result 1: ~p~n", [R1]),
    io:format(user, "Result 2: ~p~n", [R2]).

solve_1(Input) ->
    solve_1(Input, 2020).

solve_1([H|T], Expected) ->
    Rest = Expected - H,
    case lists:member(Rest, T) of
        true ->
            H * Rest;
        false ->
            solve_1(T, Expected)
    end;
solve_1([], _) ->
    false.


solve_2([H|T]) ->
    Rest = 2020 - H,
    case solve_1(T, Rest) of
        false ->
            solve_2(T);
        Result ->
            Result * H
    end.


input() ->
    {ok, Binary} = file:read_file("input1.txt"),
    Parts = binary:split(Binary, <<"\n">>, [global]),
    [binary_to_integer(X) || X <- Parts,
                              X /= <<>>].
