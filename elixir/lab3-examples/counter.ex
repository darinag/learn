defmodule Counter do
    def update(counter) do
        IO.puts(inspect(counter))
        # Note that the receive block evaluates
        # to the new value of the couter variable.
        # This value needs to be rebound to the counter 
        # variable outside the receive block to make it available
        # for being used as argument for the update/1 
        # function
        counter = receive do
            {"+", n} -> counter = counter + n
            {"-", n} -> counter = counter - n
        end
        update(counter)
    end
end

# Try to run the code below from the IEX shell.

# pid = spawn(Counter, :update, [0])

# send(pid, {"+", 100})
# send(pid, {"-", 90})
# send(pid, {"+", 1})

# Take a note of the server printouts.
# Make sure they are consistent with the expected behaviour.

# Modify the server code to make it to reply back to a client
# with a new value of the counter. Use receive blocks 
# on the client side to process the server's replies.
# Test your implementation.
# 
# Modify the server code to recognize the {:exit} message, and
# terminate its execution upon receiving {:exit} from a client.
# Test your implementation.