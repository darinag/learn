defmodule GuessingGameServer do

    def mid(low, high) do
        div(low+high, 2)
    end

    def guess(clients) do 
        receive do
            msg = {:init, low, high, client} ->
                IO.puts("INCPECT CURRENT CLIENTS STATE: " <> inspect(clients))
                IO.puts("INIT #{inspect(msg)}")
                # Compute the initial guess and send it back to the client
                # Map.put(map, key, value)
                clients = Map.put_new(clients, client, {low, high, cand=mid(low, high)})
                send(client, {:guess, cand})
                guess(clients)
            
            msg = {:lt, client} ->
                IO.puts("INCPECT CURRENT CLIENTS STATE: " <> inspect(clients))
                IO.puts("LT #{inspect(msg)}")
                {low, high, cand} = clients[client]
                new_cand = mid(cand, low)

                clients = Map.put(clients, client, {new_cand, low, cand})

                send(client, {:guess, new_cand})
                guess(clients)

            msg = {:gt, client} ->
                IO.puts("INCPECT CURRENT CLIENTS STATE: " <> inspect(clients))
                IO.puts("GT #{inspect(msg)}")
                # The client indicated that the secret number is greater than
                # cand. Add a code to compute
                # the new candidate and upper boundary of the
                # range and send them back to client in a :guess message
                # {:guess, ..., ..., ...}
                {low, high, cand} = clients[client]
                
                new_cand = mid(cand, high)
                clients = Map.put(clients, client, {new_cand, cand, high})

                send(client, {:guess, new_cand})
                guess(clients)
            
            msg = {:eq, client} ->
                IO.puts("INCPECT CURRENT CLIENTS STATE: " <> inspect(clients))
                IO.puts("EQ #{inspect(msg)}")
                # The client indicated that the secret number is greater than
                # cand. Add a code to compute
                # the new candidate and upper boundary of the
                # range and send them back to client in a :guess message
                # {:guess, ..., ..., ...}
                {low, high, cand} = clients[client]
                IO.puts("Your number is #{cand}")
                IO.puts("bye from whole server")
                guess(Map.delete(clients, client))
                send(client, {:exit})
        end
    end
end



defmodule GuessingGameClient do
    def start_game(server, low, high) do
        # Send an :init message to the server to solicit the first guess
        send(server, {:init, low, high, self()})
        # Commence the game loop
        play(server)
    end

    def play(server) do
        receive do
            msg = {:guess, cand} ->
                IO.puts("Got #{inspect(msg)} from server")
                IO.puts("Server guess is #{cand}")
                # Server guess received. Add a code
                # to ask user for the next hint.
                # Add a code to process the user's hint
                # and send it to the server in an :lt or :gt
                # message. Use self() to obtain the client pid
                # If the server successfully guessed the number,
                # notify the user, and exit.
                # Otherwise call play(server)
                # recursively to continue the loop.

                hint = String.to_atom(String.trim(IO.gets("Say lt, gt, or eq? \n")))
                send(server, {hint, self()})
                play(server)
            {:exit} ->
                IO.puts("Bye from client!")
        end
    end
end


# TORUN:
# pid = spawn(GuessingGameServer, :guess, [%{}])