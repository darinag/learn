defmodule GuessingGame do
    # This function spawns the server and 
    # registers it under the provided name, e.g., 
    # GuessingGame.start_server(:my_server)
    def start_server(name) do
        pid = spawn(GuessingGame, :guess, [%{}])
        :global.register_name(name, pid)
    end
    
    def mid(low, high) do
        div(low + high, 2)
    end

    def guess(clients) do
        receive do
            {:init, low, high, client} ->
                clients = Map.put_new(clients, client, {low, high, guess = mid(low, high)})
                send(client, {:guess, guess})
                guess(clients)
            {:lt, client} -> 
                {low, high, guess} = clients[client]
                clients = (fn h -> %{ clients | client => {low, h, mid(low, h)}} end).(max(guess-1, low))
                send(client, {:guess, elem(clients[client], 2)})
                guess(clients)
            {:gt, client} ->
                {low, high, guess} = clients[client]
                clients = (fn l -> %{ clients | client => {l, high, mid(l, high)}} end).(min(guess+1, high))
                send(client, {:guess, elem(clients[client], 2)})
                guess(clients)
            {:eq, client} ->
                guess(Map.delete(clients, client))
            {:exit} -> IO.puts("bye")
        end 
    end

    # This function starts a client that connects to the 
    # server registered under the provided name, and
    # initiates the guessing game for the provided low to high range. E.g.,
    # GuessingGame.start_game(:my_server, 1, 100)
    # Note that different clients can play the game with different ranges
    # against the same server. For example, one client can be started with
    # GuessingGame.start_game(:my_server, 1, 10)
    # and another one with
    # GuessingGame.start_game(:my_server, 1, 100)
    # You can try this out by running clients from different nodes.
    def start_game(server, low, high) do
        send(spid = :global.whereis_name(server), {:init, low, high, self()})
        play(spid)
    end

    def play(server) do
        receive do
            {:guess, cand} ->
                a = ask_for_input(cand)
                cond do
                    a in [:lt, :gt] -> 
                        send(server, {a, self()})
                        play(server)
                    a == :eq -> 
                        IO.puts("Your number is #{cand}")
                        send(server, {:eq, self()})
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
end