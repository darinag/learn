defmodule Paxos3 do
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
    pid = spawn(Paxos, :init, [name, participants, upper_layer]) 
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
    send(pid, {:propose, val, ballot})
  end

  def start_ballot(pid) do
    send(pid, {:start_ballot})
  end


  defp run(state) do
    # maintain the state
    state = receive do 

        {:propose, val, ballot} -> 
            state = %{ state | proposed_val: val}
            state = %{ state | b_val: val}
            state = %{ state | b_num: ballot}
            state
    
            #IO.puts("Just got a propose func !! My name is: #{state.name} amd my state is: ")
            #IO.inspect(state)
            run(state)

        {:start_ballot} ->
            state = %{ state | b_num: state.b_num+1}
            # leader sends all that a ballot is prepped
            for p <- state.participants do
                case :global.whereis_name(p) do
                    :undefined -> :undefined
                    p -> send(p, {:prepare, state.b_num, self()})
                end
            end
            run(state)

        # {:prepare, b_num, leader} ->
        #     #IO.puts("Im #{state.name} and I GOT HERE, state.b_num is #{state.b_num } and b_num is #{b_num} and state.b_num <= b_num is #{state.b_num <= b_num} ")
        #     send(leader, {:prepared, b_num, state.b_num, state.b_val}) 

        {:prepare, b_num, leader} -> 
            #IO.inspect(leader)
            #IO.puts("Im #{state.name} and I GOT HERE, state.b_num is #{state.b_num } and b_num is #{b_num} and state.b_num <= b_num is #{state.b_num <= b_num} ")
            if state.b_num < b_num do # if its < or = it will always get the value of the leader cos it has the highest b_num which is considered
                #IO.puts('heeeeree')
                # #IO.puts(b_num)
                # #IO.puts(state.b_num)
                # #IO.puts(state.b_val)
                # #IO.inspect(leader)
                send(leader, {:prepared, b_num, state.b_num, state.b_val}) 
            else
                #IO.puts('heeeeree -1-1-1-1')
                send(leader, {:prepared, -1}) # when participated in a higher ballot
            end

            run(state)
           
        {:prepared, b_num, old_b, old_v} ->
            #IO.puts('lqlllq in :prepared')
            state = %{ state | quorum: state.quorum+1}
            state = %{ state | quorum_res: MapSet.put(state.quorum_res, {old_b, old_v})}
            state
            
            # if old_v != :none do #add (b, v) only when v != :none so that its easier when need to check if all values are none
            #     # state = %{ state | quorum_res: {old_b, old_v}}
            #     #IO.puts('Before')
            #     #IO.inspect(state)
            #     # state = %{state | quorum_res: MapSet.put(state.quorum_res, {old_b, old_v})}
            #     state = %{ state | quorum_res: MapSet.put(state.quorum_res, {old_b, old_v})}
            #     state
            #     # IO.puts('after')
            #     # IO.inspect(state)
            # end

            # IO.puts('after')
            # IO.inspect(state)

            if state.quorum >= state.n / 2 do #start the accept phase
                #IO.puts('ffffff')
                #IO.inspect(state)
                #IO.puts("is setmapt empty? #{MapSet.size(state.quorum_res) == 0}")
                # if all quorum_res == :none then quorum_res is empty
                if MapSet.size(state.quorum_res) === 0 do
                    #IO.puts('INSIDE WHEN QUORUM RES == 0 NOOOOOOOOOO')
                    for p <- state.participants do
                        case :global.whereis_name(p) do
                            :undefined -> :undefined
                            p -> send(p, {:accept, b_num, state.proposed_val, self})
                        end
                    end
                else
                    IO.puts("INSIDE THE ELSE YAAAAAAAY")
                    #todo search for the highest b_num and sends its b_val
                    IO.inspect(state)
                    IO.puts(is_map(state.quorum_res))
                    # IO.puts(Enum.sort_by(&(elem(&1, 0))))
                    sorted_quorum_res  = state.quorum_res |> Enum.sort_by(&(elem(&1, 0)))
                    IO.puts("SORTED QUORUM RES:")
                    IO.inspect(sorted_quorum_res)
                    highest_b_val = Enum.take(sorted_quorum_res, -1) |> Enum.at(0) |> Tuple.to_list |> Enum.at(1)
                    IO.puts("HIGHEST B VAL SO FAR RES: #{highest_b_val}")
                    
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
            #IO.puts('in :accept phase')
            #IO.inspect(state)

            if state.b_num == :none or state.b_num < bal_num do
                state = %{ state | b_num: bal_num}
                state = %{ state | b_val: bal_val}
                state

                # IO.puts('INSIDEEEEE')
                # IO.inspect(state)

                send(leader, {:accepted, bal_num, bal_val}) 
            end
            run(state)

        {:accepted, b_num, b_val} ->
            state = %{ state | quorum_accept: state.quorum_accept+1}
            state
            #IO.puts("in :accepted phase")
            #IO.inspect(state)
            if state.quorum_accept >= state.n / 2 do #consensus has been achieved
                # update leader's state maybe??
                state = %{ state | b_num: b_num}
                state = %{ state | b_val: b_val}
                state

                # IO.puts("here")
                # IO.inspect(state)
                
                # restart quorum_res and quorum_accept
                # state = %{ state | quorum_res: MapSet.new()}
                # state = %{ state | quorum_accept: 0}
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