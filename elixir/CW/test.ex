defmodule Paxos2 do
    # prepare phase
    # receive prepare phase message: {:prepare, b}, check its last b number
    # if old_b < prepare_b: reply with {:prepared, b, {b_old, v_old}}
    # if no b_old: {:prepared, b, {:none}}

    # accept phase
    # receive {:accept, b, v} and node own ballot < b =>
    # store {b, v} in {b_old, v_old}

    # decision propagation
    # process receives {:decided, v} => notifies the app for decision

    #   defp prep_phase() do
#     # start the prepare phase => broadcast {:prepare, b}
#     # check what it have received: receive do {:prepared, b, {b_old, v_old}} or {:none}
#     # wait until the majority of nodes voted so when n > 2f can start the accept phase
#   end

#   defp accept_phase() do
#     # 1) select a value V to propose
#     # if all :prepared msgs are :none then v=value when proposed()
#     # else v=v_old where b_old is the highest
#     # 2) inform everyone by send {:accep, b, v}
#     # when collects quorum of {:accepted, b}, consensus on v has been reached
#     # propagates {:decided, v} to all processes
#   end


  def start(name, participants, upper_layer) do
    pid = spawn(Paxos2, :init, [name, participants, upper_layer]) 
    :global.unregister_name(name)
    case :global.register_name(name, pid) do #MAPS NAME TO PID
      :yes -> pid  
      :no  -> :error
    end
    # return the P id to pass it to propose and start_ballot
  end

  def init(name, participants, upper) do 
    state = %{ 
        name: name, 
        upper: upper,
        b_num: 0,
        b_val: :none,
        proposed_val: 0,
        participants: participants,
        n: Enum.count(participants),
        quorum: 0, #number of collected opinions 
        quorum_res: MapSet.new(),
        quorum_accept: 0
     }
     run(state)
  end


  def propose(pid, val) do
    # state = %{ state | history: MapSet.put(state.history, {0, val}) # (pid, (b_num, b_val))
    send(pid, {:propose, val})
  end

  def start_ballot(pid) do
    send(pid, {:start_ballot, self()})
  end


  defp run(state) do
    # maintain the state
    state = receive do 

        {:propose, val} -> 
            state = %{ state | proposed_val: val}
            state = %{ state | b_val: val}
            state
            # IO.inspect(state)
            run(state)

        {:start_ballot, leader} ->
            state = %{ state | b_num: state.b_num+1}
            # leader sends all that a ballot is prepped
            for p <- state.participants do
                case :global.whereis_name(p) do
                    :undefined -> :undefined
                    p -> send(p, {:prepare, state.b_num, state.b_val, self()})
                end
            end
            run(state)

        {:prepare, b, v, leader} ->
            IO.puts("here??")
            send(leader, {:prepared, state.b_num, state.b_val}) 
            run(state)

        {:prepared, b, v} ->
            IO.puts("IN :PREPARED")
            # IO.puts("HEHEHEHHEHEHE")
            # IO.puts("STATE BEFORE:")
            # IO.inspect(state)
            state = %{ state | quorum_res: MapSet.put(state.quorum_res, {b, v}) }
            state
            IO.puts("STATE AFTER:")
            IO.inspect(state)
        # {:decided, b_val} ->
        #     IO.puts("Got #{inspect(msg)}")
        #     IO.puts('heheheh')
        #     # inform upper layer that the decision was made
        #     # send(state.upper, {:})

        _ -> state  # Important: we do not want non-consumed messages to stuck
                    # in the process mailbox forever
    end
    run(state)
  end      
end