defmodule GuessingGame do
    def mid(low, high) do
        div(low + high, 2)
    end

    def play(low, high) when low < high do
        ask(mid(low, high), low, high)
    end

    def play(low, high) do
        {:error, {:invalid_arguments, {:low, low}, {:high, high}}}
    end

    def guess(:lt, cand, low, _) do
        new_high = max(cand-1, low)
        ask(mid(low, new_high), low, new_high)
    end

    def guess(:gt, cand, _, high) do
        new_low = min(cand+1, high)
        ask(mid(new_low, high), new_low, high)
    end

    def guess(:eq, cand, _, _) do
        IO.puts("Your number is #{cand}.")
    end

    def guess(_, cand, low, high) do
        IO.puts("Enter either \"lt\", \"gt\", or \"eq\"")
        ask(cand, low, high)
    end

    def ask(cand, low, high) do
        hint = String.to_atom(String.trim(IO.gets("#{cand} lt/gt/eq: ")))
        guess(hint, cand, low, high)
    end

end