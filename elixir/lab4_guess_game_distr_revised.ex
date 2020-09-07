defmodule GuessingGameServer do

    def mid(low, high) do
        div(low+high, 2)
    end

    def guess() do
        receive do
            msg = {:init, low, high, client} ->
                IO.puts("INIT #{inspect(msg)}")
                # Compute the initial guess and send it back to the client
                send(client, {:guess, mid(low, high), low, high})
                guess()
            
            msg = {:lt, cand, low, _, client} ->
                IO.puts("LT #{inspect(msg)}")
                # The client indicated that the secret number is less than
                # cand. Add a code to compute
                # the new candidate and upper boundary of the
                # range and send them back to client in a :guess message
                # {:guess, ..., ..., ...}
                send(client, {:guess, mid(cand, low), low, cand})
                guess()
            msg = {:gt, cand, _, high, client} ->
                IO.puts("GT #{inspect(msg)}")
                # The client indicated that the secret number is greater than
                # cand. Add a code to compute
                # the new candidate and upper boundary of the
                # range and send them back to client in a :guess message
                # {:guess, ..., ..., ...}
                send(client, {:guess, mid(cand, high), cand, high})
                guess()
            
            msg = {:eq, cand, _, _, client} ->
                IO.puts("EQ #{inspect(msg)}")
                # The client indicated that the secret number is greater than
                # cand. Add a code to compute
                # the new candidate and upper boundary of the
                # range and send them back to client in a :guess message
                # {:guess, ..., ..., ...}
                IO.puts("Your number is #{cand}")
                IO.puts("bye from whole server")
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
            msg = {:guess, cand, low, high} ->
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
                send(server, {hint, cand, low, high, self()})
                play(server)
            {:exit} ->
                IO.puts("Bye from client!")
        end
    end
end


# TO RUN:
# start the server:
# pid = spawn(GuessingGameServer, :guess, []) 
# start the game:
# GuessingGameClient.start_game(pid, 1, 100)
