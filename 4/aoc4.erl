-module(aoc4).

-export([solve/0,
         valid_year/2,
         valid_height/2,
         valid_atom/2,
         valid_regex/2]).


solve() ->
    Input = input(),
    R1 = solve_1(Input),
    R2 = solve_2(Input),
    io:format(user, "Result 1: ~p~n", [R1]),
    io:format(user, "Result 2: ~p~n", [R2]).


solve_1(Passports) ->
    length(lists:filter(fun valid_passport_1/1, Passports)).

solve_2(Passports) ->
    length(lists:filter(fun valid_passport_2/1, Passports)).


valid_passport_1(Passport) ->
    RequiredKeys = [byr, iyr, eyr, hgt, hcl, ecl, pid],
    Keys = [ Key || {Key, _} <- Passport, lists:member(Key, RequiredKeys) ],
    length(lists:usort(Keys)) == length(RequiredKeys).

valid_passport_2(Passport) ->
    RequiredKeys = [{byr, valid_year, {1920, 2002}},
                    {iyr, valid_year, {2010, 2020}},
                    {eyr, valid_year, {2020, 2030}},
                    {hgt, valid_height, undefined},
                    {pid, valid_regex, {"^([0-9]+)$", 9}},
                    {hcl, valid_regex, {"^(#[0-9a-f]+)$", 7}},
                    {ecl, valid_atom, [amb, blu, brn, gry, grn, hzl, oth]}],
    lists:foldl(fun(_, false) ->
                        false;
                   ({Key, Fun, Data}, true) ->
                        Value = proplists:get_value(Key, Passport),
                        try
                            ?MODULE:Fun(string:trim(Value), Data)
                        catch
                            _:_ ->
                                false
                        end
                end, true, RequiredKeys).

valid_year(Value, {Min, Max}) ->
    Number = binary_to_integer(Value),
    Min =< Number andalso Max >= Number.

valid_height(Value, undefined) ->
    case binary:split(Value, <<"in">>) of
        [N, <<>>] ->
            Number = binary_to_integer(N),
            59 =< Number andalso 76 >= Number;
        _ ->
            case binary:split(Value, <<"cm">>) of
                [N, <<>>] ->
                    Number = binary_to_integer(N),
                    150 =< Number andalso 193 >= Number
            end
    end.

valid_regex(Value, {Re, Pos}) ->
    {match, [{0, Pos}, {0, Pos}]} = re:run(Value, Re),
    true.

valid_atom(Value, ValidAtoms) ->
    lists:member(binary_to_existing_atom(Value, utf8), ValidAtoms).

input() ->
    {ok, Binary} = file:read_file("input4.txt"),
    Rows = binary:split(Binary, <<"\n">>, [global]),
    {[], Passports} = lists:foldl(fun(<<>>, {[], _} = Acc) ->
                                          Acc;
                                     (<<>>, {Current, All}) ->
                                          {[], [Current|All]};
                                     (R, {Current, All}) ->
                                          {binary:split(R, <<" ">>, [global]) ++ Current, All}
                                  end, {[], []}, Rows),
    [ parse_passport(P) || P <- Passports ].

parse_passport(Passport) ->
    lists:map(fun(X) ->
                      [Key, Value] = binary:split(X, <<":">>),
                      {binary_to_atom(Key, utf8), Value}
              end, Passport).
