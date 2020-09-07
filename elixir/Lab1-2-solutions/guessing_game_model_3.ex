defmodule GuessingGame do
    def mid(low, high) do
        div(low + high, 2)
    end

    def play(low, high) when low < high do
        ask(mid(low, high), low, high, 0)
    end

    def play(low, high) do
        {:error, {:invalid_range, {:low, low}, {:high, high}}}
    end

    def guess(:lt, cand, low, _, count) do
        new_high = max(cand-1, low)
        ask(mid(low, new_high), low, new_high, count + 1)
    end

    def guess(:gt, cand, _, high, count) do
        new_low = min(cand+1, high)
        ask(mid(new_low, high), new_low, high, count + 1)
    end

    def guess(:eq, cand, _, _, count) do
        IO.puts("secret number=#{cand}, attempts=#{count}")
    end

    def guess(_, cand, low, high, count) do
        IO.puts("Enter either \"lt\", \"gt\", or \"eq\"")
        ask(cand, low, high, count)
    end

    def ask(cand, low, high, count) do
        hint = String.to_atom(String.trim(IO.gets("#{cand} lt/gt/eq: ")))
        guess(hint, cand, low, high, count)
    end

end