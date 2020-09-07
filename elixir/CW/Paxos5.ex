defmodule Paxos5 do
    # prepare phase
    # receive prepare phase message: {:prepare, b}, check its last b number
    # if old_b < prepare_b: reply with {:prepared, b, {b_old, v_old}}
    # if no b_old: {:prepared, b, {:none}}

    # accept phase
    # receive {:accept, b, v} and node own ballot < b =>
    # store {b, v} in {b_old, v_old}

    # decision propagation
    # process receives {:decided, v} => notifies the app for decision

  def start(name, participants, upper_layer) do
    pid = spawn(Paxos, :init, [name, participants, upper_layer]) 
    :global.unregister_name(name)
    case :global.register_name(name, pid) do #MAPS NAME TO PID
      :yes -> pid  
      :no  -> :error
    end
  end

  def init(name, participants, upper) do 
    state = %{ 
        name: name, 
        upper: upper,
        b_num: 0,
        curr_b_num: -1,
        b_val: -1,
        proposed_val: -1,
        participants: participants,
        n: Enum.count(participants),
        quorum_res_ctr: 0, #number of collected opinions 
        #quorum_res: MapSet.new(), # b_num, b_val
        highest_b: -1,
        highest_v: -1,
        quorum_accept_ctr: 0
     }
     run(state)
  end

  def propose(pid, val) do
    send(pid, {:propose, val})
  end

  def start_ballot(pid) do
    send(pid, {:start_ballot})
  end


  defp run(state) do
    state = receive do 

        {:propose, val} -> 
            state = %{ state | proposed_val: val}
            # state = %{ state | b_val: val}
            # state = %{ state | curr_b_num: ballot}
            state
            run(state)

        {:start_ballot} ->
            state = %{ state | curr_b_num: state.b_num+1}
            IO.puts("STARTING A BALLOT...")
            # leader sends all that a ballot is prepped
            for p <- state.participants do
                case :global.whereis_name(p) do
                    :undefined -> :undefined
                    p -> send(p, {:prepare, state.curr_b_num, self()})
                end
            end
            run(state)

        {:prepare, b_num, leader} -> 
            IO.puts("in :PREPARE, I'm #{state.name}")
            if state.b_num <= b_num do 
                send(leader, {:prepared, b_num, state.b_num, state.b_val}) 
            else
                IO.puts("in -1-1-1-1-1-")
                send(leader, {:prepared, -1}) # when participated in a higher ballot
            end
            run(state)
           
        {:prepared, b_num, old_b, old_v} ->
        # add if to go into the inly if quorum ctr < n/2
            IO.puts("in :PREPARED, i'm the LEADER")
            state = %{ state | quorum_res_ctr: state.quorum_res_ctr+1}
            state
            IO.puts("HEHEHEHEEHEHEHEEHEHEHEHE")
            IO.puts("Currently i have as old_b #{old_b} and as old_v #{old_v} while in my state I hvae:")
            # IO.inspect(state)
            # state = %{ state | quorum_res: MapSet.put(state.quorum_res, {old_b, old_v})}
            state = if (state.highest_b == old_b and state.highest_b < old_v) or (state.highest_b < old_b) or (state.highest_b == -1) do
                IO.puts("INININININ")
                if state.highest_b == -1 do
                    %{ state | highest_b: state.proposed_val}
                else
                    state = %{ state | highest_b: old_b}
                    %{ state | highest_v: old_v}
                end
                IO.inspect(state)
                IO.puts("--- over ---")
            end
            

            IO.inspect(state)
            IO.puts("---over----")

            if state.quorum_res_ctr >= state.n / 2 do #start the accept phase
                IO.puts("IN QUORUM RESPONSE CTR")
                #IO.puts('ffffff')
                #IO.inspect(state)
                #IO.puts("is setmapt empty? #{MapSet.size(state.quorum_res) == 0}")
                # if all quorum_res == :none then quorum_res is empty
                # if MapSet.size(state.quorum_res) === 0 do
                #     #IO.puts('INSIDE WHEN QUORUM RES == 0 NOOOOOOOOOO')
                #     for p <- state.participants do
                #         case :global.whereis_name(p) do
                #             :undefined -> :undefined
                #             p -> send(p, {:accept, b_num, state.proposed_val, self})
                #         end
                #     end
                # else
                #     IO.puts("INSIDE THE ELSE YAAAAAAAY")
                #     #todo search for the highest b_num and sends its b_val
                #     IO.inspect(state)
                #     IO.puts(is_map(state.quorum_res))
                #     # IO.puts(Enum.sort_by(&(elem(&1, 0))))
                #     sorted_quorum_res  = state.quorum_res |> Enum.sort_by(&(elem(&1, 0)))
                #     IO.puts("SORTED QUORUM RES:")
                #     IO.inspect(sorted_quorum_res)
                #     highest_b_val = Enum.take(sorted_quorum_res, -1) |> Enum.at(0) |> Tuple.to_list |> Enum.at(1)
                #     IO.puts("HIGHEST B VAL SO FAR RES: #{highest_b_val}")
                    
                #update the leader value?

                IO.puts('WTFFFFFFF')
                IO.puts(state.proposed_val)
                IO.inspect(state)

                state = %{ state | b_val: state.highest_b }
                state
                IO.puts("Im the leader and updating my highest b to be #{state.highest_b} and starting to inform all for the decision. My state is: ")
                # IO.inspect(state)

                for p <- state.participants do
                    case :global.whereis_name(p) do
                        :undefined -> :undefined
                        p -> send(p, {:accept, b_num, state.highest_b, self})
                    end
                end
            end

            run(state)

        
        {:accept, bal_num, bal_val, leader} ->

            IO.puts("My name is #{state.name} and I have accepted the val from the leader!!")
            if state.b_num == :none or state.b_num < bal_num do
                state = %{ state | b_num: bal_num}
                state = %{ state | b_val: bal_val}
                state

                send(leader, {:accepted, bal_num, bal_val}) 
            end
            run(state)

        {:accepted, b_num, b_val} ->
            # if .... status in state
            IO.puts("Im the leader and hvae just received an accepted msg")
            state = %{ state | quorum_accept_ctr: state.quorum_accept_ctr+1}
            state
            #IO.puts("in :accepted phase")
            #IO.inspect(state)
            if state.quorum_accept_ctr >= state.n / 2 do #consensus has been achieved
               IO.puts("Im the leader and consensus has been achieved!!! Starting to inform the rest")
                # update leader's state maybe??
                state = %{ state | b_val: b_val}
                state = %{ state | b_num: state.curr_b_num}
                state
                
                # restart quorum_res and quorum_accept_ctr??
                # state = %{ state | quorum_res: MapSet.new()}
                # state = %{ state | quorum_accept_ctr: 0}
                # state

                #IO.puts('LEADERS STATE')
                #IO.inspect(state)

                for p <- state.participants do
                    case :global.whereis_name(p) do
                        :undefined -> :undefined
                        p -> send(state.upper, {:decided, b_val})
                    end
                end
            end

            run(state)

        _ -> run(state)  # Important: we do not want non-consumed messages to stuck
                    # in the process mailbox forever
    end
    # run(state)
 end         
end