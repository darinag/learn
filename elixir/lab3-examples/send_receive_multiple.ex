defmodule SendReceiveMultiple do
  
  def greet() do
    receive do 
      {sender, msg} -> 
        send(sender, {:ok,"Hello #{msg}"})
        greet()
      {:exit} -> IO.puts("bye")  
    end
  end

end

# Try to run the code below from the IEX shell.
# Use the IEX flush() function (as shown below) to purge
# all outstanding messages from the process
# mailbox

# pid = spawn(SendReceiveMultiple, :greet, [])

# send(pid, {self, "World!"})

# receive do
#   {:ok, message} -> IO.puts(message)
# end

# flush()

# send(pid, {self, "again!"})

# receive do
#   {:ok, message} -> IO.puts(message)
#   after 500 -> IO.puts("No one there it seems...")
# end

# flush()