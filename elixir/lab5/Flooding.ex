defmodule FloodingBC do

  def start(name, neighbours, upper) do
    pid = spawn(FloodingBC, :init, [name, 0, neighbours, upper]) 
    :global.unregister_name(name)
    case :global.register_name(name, pid) do #MAPS NAME TO PID
      :yes -> pid  
      :no  -> :error
    end
  end

  def init(name, next, neighbours, upper) do 
    state = %{ 
        name: name, 
        next: next,
        upper: upper,
        # received: MapSet.new(),  # set of {pid, seqno} pairs
        neighbours: neighbours  
     }
     run(state)
  end

  def bc_send(bcast, msg) do
    send(bcast, {:input, :bc_send, msg})
  end

  defp run(state) do
    my_pid = self()
    state = receive do 
      {:input, :bc_send, msg} -> 
        # IO.inspect(state)
        for p <- state.neighbours do
          case :global.whereis_name(p) do
            :undefined -> :undefined
            pid -> send(pid, {:output, :bc_receive, state.name, msg})
            
          end
        end
        send(my_pid, {:output, :bc_receive, state.name, msg})
        state = %{ state | next: state.next + 1}
        state

      {:output, :bc_receive, origin, msg} -> 
        send(state.upper, {:output, :bc_receive, origin, msg})
        state
    end
    run(state)
  end
          
end