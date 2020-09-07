defmodule GuessingGame do
    def play(:binary, low, high) when low < high do
        strat = fn(x, y) -> div(x+y, 2) end
        ask(strat, strat.(low, high), low, high, 0)
    end

    def play(:binary, low, high) do
        {:error, {:invalid_range, {:low, low}, {:high, high}}}
    end

    def play(:random, low, high) when low < high do
        strat = fn(x, y) -> Enum.random(x..y) end
        ask(strat, strat.(low, high), low, high, 0)
    end

    def play(:random, low, high) when low < high do
        {:error, {:invalid_range, {:low, low}, {:high, high}}}
    end

    def play(strategy, low, high) when low < high do
        {:error, {:invalid_strategy, strategy}}
    end

    def play(strategy, low, high) do
        {:error, {:invalid_strategy, strategy},
            {:invalid_range, {:low, low}, {:high, high}}}
    end

    def guess(:lt, f, cand, low, _, count) do
        new_high = max(cand-1, low)
        ask(f, f.(low, new_high), low, new_high, count + 1)
    end

    def guess(:gt, f, cand, _, high, count) do
        new_low = min(cand+1, high)
        ask(f, f.(new_low, high), new_low, high, count + 1)
    end

    def guess(:eq, _, cand, _, _, count) do
        IO.puts("secret number=#{cand}, attempts=#{count}")
    end

    def guess(_, f, cand, low, high, count) do
        IO.puts("Enter either \"lt\", \"gt\", or \"eq\"")
        ask(f, cand, low, high, count)
    end

    def ask(f, cand, low, high, count) do
        hint = String.to_atom(String.trim(IO.gets("#{cand} lt/gt/eq: ")))
        guess(hint, f, cand, low, high, count)
    end

end