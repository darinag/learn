defmodule PaxosSafe do

  def start(name, participants, upper_layer) do
    pid = spawn(Paxos, :init, [name, participants, upper_layer]) 
    :global.unregister_name(name)
    case :global.register_name(name, pid) do 
      :yes -> pid  
      :no  -> :error
    end
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
    send(pid, {:propose, val, ballot})
  end

  def start_ballot(pid) do
    send(pid, {:start_ballot})
  end


  defp run(state) do
    state = receive do 

        {:propose, val, ballot} -> 
            state = %{ state | proposed_val: val}
            state = %{ state | b_val: val}
            state = %{ state | b_num: ballot}
            state
            run(state)

        {:start_ballot} ->
            state = %{ state | b_num: state.b_num+1}
            for p <- state.participants do
                case :global.whereis_name(p) do
                    :undefined -> :undefined
                    p -> send(p, {:prepare, state.b_num, self()})
                end
            end
            run(state)

        {:prepare, b_num, leader} -> 
            if state.b_num <= b_num do 
                send(leader, {:prepared, b_num, state.b_num, state.b_val}) 
            else
                send(leader, {:prepared, -1}) # when participated in a higher ballot
            end
            run(state)
           
        {:prepared, b_num, old_b, old_v} ->
            state = %{ state | quorum: state.quorum+1}
            state = %{ state | quorum_res: MapSet.put(state.quorum_res, {old_b, old_v})}
            state

            if state.quorum >= state.n / 2 do #start the accept phase
                if MapSet.size(state.quorum_res) === 0 do
                    for p <- state.participants do
                        case :global.whereis_name(p) do
                            :undefined -> :undefined
                            p -> send(p, {:accept, b_num, state.proposed_val, self})
                        end
                    end
                else
                    sorted_quorum_res  = state.quorum_res |> Enum.sort_by(&(elem(&1, 0)))
                    highest_b_val = Enum.take(sorted_quorum_res, -1) |> Enum.at(0) |> Tuple.to_list |> Enum.at(1)
                
                    #update the leader value??
                    state = %{ state | b_val: highest_b_val }
                    state

                    for p <- state.participants do
                        case :global.whereis_name(p) do
                            :undefined -> :undefined
                            p -> send(p, {:accept, b_num, highest_b_val, self})
                        end
                    end
                end
            end

            run(state)

        
        {:accept, bal_num, bal_val, leader} ->
            if state.b_num == :none or state.b_num < bal_num do
                state = %{ state | b_num: bal_num}
                state = %{ state | b_val: bal_val}
                state
                send(leader, {:accepted, bal_num, bal_val}) 
            end
            run(state)

        {:accepted, b_num, b_val} ->
            state = %{ state | quorum_accept: state.quorum_accept+1}
            state

            if state.quorum_accept >= state.n / 2 do #consensus has been achieved
                # update leader's state maybe??
                state = %{ state | b_num: b_num}
                state = %{ state | b_val: b_val}
                state

                for p <- state.participants do
                    case :global.whereis_name(p) do
                        :undefined -> :undefined
                        p -> send(state.upper, {:decided, b_val})
                    end
                end
            end

            run(state)

        _ -> state  # we do not want non-consumed messages to stuck
                    # in the process mailbox forever
    end
    run(state)
  end
          
end