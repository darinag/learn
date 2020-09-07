defmodule GuessingGame do
    # c "guess_game.ex"      GuessingGame.play(0,20) 

    def cnt do
        0
    end

    def cnt(x) do
        x + 1
    end

    def mid(low, high) do
        div(low+high, 2)
    end

    def ask(candidate, low, high) do
        IO.puts("My guess is #{candidate}")
        inp = IO.gets("Depending on the status of the number say lt, gt, eq :")
        status = String.to_atom(String.trim(inp))
        guess(status, candidate, low, high)
        cnt(c)
    end

    def guess(:lt, cand, low, _) do 
        ask(mid(low, cand-1), low, cand-1)
    end

    def guess(:gt, cand, _, high) do
        ask(mid(cand+1, high), cand+1, high)
    end

    def guess(:eq, cand, _, _) do
        IO.puts("Your number is #{cand}")
    end

    def guess(_, cand, low, high) do
        IO.puts("Wrong input!")
        ask(cand, low, high)
    end

    def play(low, high) when low <= high do
        ask(mid(low, high), low, high)
        c = count()
    end

    def play(low, high) when low > high do
        IO.puts("Wrong boundries!")
    end

end