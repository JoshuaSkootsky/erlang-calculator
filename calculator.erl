-module(calculator).
-export([start/0]).

start() ->
    io:format("Welcome to the Erlang Calculator!~n"),
    calculate_loop().

calculate_loop() ->
    case get_input() of
        {ok, Num1, Op, Num2} ->
            Result = calculate(Num1, Op, Num2),
            io:format("Result: ~p~n", [Result]),
            ask_continue();
        error ->
            calculate_loop()
    end.

get_input() ->
    case get_first_number() of
        {ok, Num1} -> get_operator(Num1);
        error -> error
    end.

get_first_number() ->
    get_number("Enter a number: ").

get_operator(Num1) ->
    case get_operator_input() of
        {ok, Op} -> get_second_number(Num1, Op);
        error -> 
            io:format("Invalid operator. Please try again.~n"),
            error
    end.

get_second_number(Num1, Op) ->
    case get_number("Enter another number: ") of
        {ok, Num2} -> {ok, Num1, Op, Num2};
        error -> 
            io:format("Invalid number. Please try again.~n"),
            error
    end.

get_number(Prompt) ->
    io:format(Prompt),
    case io:fread("", "~d") of
        {ok, [Num]} -> {ok, Num};
        _ -> error
    end.

get_operator_input() ->
    io:format("Enter an operator (+, -, *, /): "),
    case io:fread("", "~s") of
        {ok, [Op]} when Op =:= "+" ; Op =:= "-" ; Op =:= "*" ; Op =:= "/" ->
            {ok, list_to_atom(Op)};
        _ ->
            error
    end.

calculate(Num1, '+', Num2) -> Num1 + Num2;
calculate(Num1, '-', Num2) -> Num1 - Num2;
calculate(Num1, '*', Num2) -> Num1 * Num2;
calculate(Num1, '/', Num2) when Num2 /= 0 -> Num1 / Num2;
calculate(_, '/', 0) -> 
    io:format("Error: Division by zero!~n"),
    error.

ask_continue() ->
    io:format("Do you want to perform another calculation? (y/n): "),
    case io:fread("", "~s") of
        {ok, ["y"]} -> calculate_loop();
        {ok, ["n"]} -> io:format("Thank you for using the Erlang Calculator. Goodbye!~n");
        _ -> 
            io:format("Invalid input. Please enter 'y' or 'n'.~n"),
            ask_continue()
    end.