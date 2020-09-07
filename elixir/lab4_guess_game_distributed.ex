defmodule GuessingGameDist do

    def mid(low, high) do
        div(low+high, 2)
    end

    def guess() do
        receive do
            msg = {:init, low, high, client} ->
                IO.puts("Got #{inspect(msg)}")
                # Compute the initial guess and send it back to the client
                send(client, {:guess, mid(low, high), low, high})
                guess()

            msg = {:lt, cand, low, _, client} ->
                IO.puts("Got #{inspect(msg)}")
                # The client indicated that the secret number is less than
                # cand. Add a code to compute
                # the new candidate and upper boundary of the
                # range and send them back to client in a :guess message
                # {:guess, ..., ..., ...}
                send(client, {:guess, mid(low, cand-1), low, cand-1})
                guess()

            msg = {:gt, cand, _, high, client} ->
                IO.puts("Got #{inspect(msg)}")
                # The client indicated that the secret number is greater than
                # cand. Add a code to compute
                # the new candidate and upper boundary of the
                # range and send them back to client in a :guess message
                # {:guess, ..., ..., ...}
                send(client, {:guess, mid(cand+1, high), cand+1, high})
                guess()

            msg = {:eq, cand, _, _, client} ->
                IO.puts("Got #{inspect(msg)}")
                # The client indicated that the secret number is greater than
                # cand. Add a code to compute
                # the new candidate and upper boundary of the
                # range and send them back to client in a :guess message
                # {:guess, ..., ..., ...}
                IO.puts("Your number is #{cand}")
                send(client, {:exit})
                
                

            {:exit} -> IO.puts("bye from here 1")
        end
    end
end


defmodule GuessingGameDistPlay do

    def startGame(server, low, high) do
        send(server, {:init, low, high, self()}) #send the initial message
        play(server, low, high)
    end

    def play(server, low, high) do
        # Send the initial message to the server to start the game
        receive do
            msg = {:guess, cand, low, high} ->
                IO.puts("Got #{inspect(msg)} from server")
                # Server guess received. Add a code
                # to ask user for the next hint.
                hint = IO.gets("Depending on the status of the guessed number say if it's lt, gt, eq :")
                hint = String.to_atom(String.trim(hint))
                IO.puts("Hint #{hint}")
                # Add a code to process the user's hint
                # and send it to the server in an :lt or :gt
                # message. Use self() to obtain the client pid
                # ans = guess(status, cand, low, high, self())
                response = send(server, {hint, low, high, self()})
                # If the server successfully guessed the number,
                # notify the user, and exit.
                # Otherwise call play(server, _, _)
                # recursively to continue the loop.
                IO.puts("Server's response #{inspect(response)}")
                play(server, elem(response, 2), elem(response, 3))
            {:exit} -> IO.puts("bye from here 2")
        end
    end
end