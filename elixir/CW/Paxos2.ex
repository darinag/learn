defmodule Paxos2 do
  
  def start(name, neighbours) do
    spawn(Routing, :init, [name, neighbours])
  end

  def start_ballot(leader) do
        # pick unique ballot number b, register the leader
  end

  def prep_phase() do
    # start the prepare phase => broadcast {:prepare, b}
    # check what it have received: receive do {:prepared, b, {b_old, v_old}} or {:none}
    # wait until the majority of nodes voted so when n > 2f can start the accept phase
  end

  def accept_phase() do
    # 1) select a value V to propose
    # if all :prepared msgs are :none then v=value when proposed()
    # else v=v_old where b_old is the highest
    # 2) inform everyone by send {:accep, b, v}
    # when collects quorum of {:accepted, b}, consensus on v has been reached
    # propagates {:decided, v} to all processes
  end

  def propose(p, value) do
  end

  def init(name, neighbours) do
    # init the state
    bcast = FloodingBC.start(name, neighbours, self)
    state = %{
      name: name,
      bcast: bcast
    }
    run(state)
  end 

  def send_to(routing, dest, msg) do 
    send(routing, {:input, :send_to, {dest, msg}})
  end

  defp run(state) do
    # maintain the state
    my_pid = self()
    my_name = state.name
    state = receive do 

        # prepare phase
        # receive prepare phase message: {:prepare, b}, check its last b number
        # if old_b < prepare_b: reply with {:prepared, b, {b_old, v_old}}
        # if no b_old: {:prepared, b, {:none}}

        # accept phase
        # receive {:accept, b, v} and node own ballot < b =>
        # store {b, v} in {b_old, v_old}

        # decision propagation
        # process receives {:decided, v} => notifies the app for decision


      {:input, :send_to, msg} -> 
        FloodingBC.bc_send(state.bcast, msg)
        state

      {:output, :bc_receive, sender, {dest, msg}} when dest == my_name -> 
        send(my_pid, {:output, :receive, sender, msg})
        state

      {:output, :receive, sender, msg} ->
        IO.puts("#{my_name}: received message #{inspect msg} from #{sender}")
        state

      _ -> state  # Important: we do not want non-consumed messages to stuck
                  # in the process mailbox forever
    end
    run(state)
  end
          
end