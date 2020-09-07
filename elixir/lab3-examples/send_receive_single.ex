defmodule SendReceiveSingle do
    def greet() do
        receive do
            {sender, "hello"} -> IO.puts("received hello")
            {sender, msg} -> IO.puts("something else")
        end
    end
end

# Try to run the code below from the IEX shell.

# pid = spawn(SendReceiveSingle, :greet, [])

# send(pid, {self(), "hello"})

# Restart the server process, and try a different 
# message. Take note of the server outputs

# pid = spawn(SendReceiveSingle, :greet, [])

# send(pid, {self(), "Good morning!"})