defmodule GuessingGame do
    def mid(low, high) do
        div(low + high, 2)
    end

    def guess() do
        receive do
            {:init, low, high, client} ->
                send(client, {:guess, mid(low, high), low, high})
                guess()
            {:lt, cand, low, _, client} -> 
                new_high = max(cand-1, low)
                send(client, {:guess, mid(low, new_high), low, new_high})
                guess()
            {:gt, cand, _, high, client} ->
                new_low = min(cand+1, high)
                send(client, {:guess, mid(new_low, high), new_low, high})
                guess()
            {:exit} -> IO.puts("bye")
        end 
    end

    def start_game(server, low, high) do
        # Send an :init message to the server to solicit the first guess
        send(server, {:init, low, high, self()})
        # Commence the game loop
        play(server)
    end

    def play(server) do
        receive do
            {:guess, cand, low, high} ->
                a = ask_for_input(cand)
                cond do
                    a in [:lt, :gt] -> 
                        send(server, {a, cand, low, high, self()})
                        play(server)
                    a == :eq -> IO.puts("Your number is #{cand}")
                end
        end
    end

    def ask_for_input(cand) do
        a = String.to_atom(String.trim(IO.gets("#{inspect self()}: #{cand} lt/gt/eq: ")))
        cond do
            a in [:lt, :gt, :eq] -> a
            true -> 
                IO.puts("Enter either \"lt\", \"gt\", or \"eq\"")
                ask_for_input(cand)
        end
    end

    def start_server(name) do
        :global.register_name(name, self())
        GuessingGame.guess()
    end
end