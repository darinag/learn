defmodule StatefulCalculator do

    # --------------------------------------------
    # ------- CLIENT INTERFACE FUNCTIONS ---------
    
    def start do
        spawn(fn -> loop(0) end)
    end

    def value(server_pid) do
        send(server_pid, {:value, self()})
        receive do
            {:response, value} ->
                value
        end
    end

    def add(server_pid, value), do: send(server_pid, {:add, value})
    def sub(server_pid, value), do: send(server_pid, {:sub, value})
    def mul(server_pid, value), do: send(server_pid, {:mul, value})
    def div(server_pid, value), do: send(server_pid, {:div, value}) 


    # --------------------------------------------
    # ------- SERVER FUNCTIONS -------------------

    # REFACTORED BELOW COS IT GETS MEESY OVER TIME WHEN ADDING NEW OPREATIONS, HANDLERS, ETC
    # defp loop(current_value) do
    #     new_val = 
    #         receive do
    #             # getter request. Retrieve the server's state
    #             {:value, caller} ->
    #                 send(caller, {:response, current_value})
    #                 current_value # (*)

    #             # arithmetic op request
    #             {:add, value} -> current_value + value
    #             {:sub, value} -> current_value - value
    #             {:mul, value} -> current_value * value
    #             {:div, value} -> current_value / value

    #             # invalid request
    #             invalid_request ->
    #                 IO.puts("invalid request #{inspect invalid_request}")
    #                 current_value
    #         end
    #     loop(new_val)
    # end


    defp loop(current_value) do
        new_value = 
            receive do
                message -> process_message(current_value, message)
            end
        loop(new_value) #VERY IMPORTANT TO CONTUNIE LISTENING
    end

    defp process_message(current_value, {:value, caller}) do
        send(caller, {:responce, current_value})
        current_value
    end

    defp process(current_value, {:add, value}) do
        current_value + value
    end

     defp process(current_value, {:sub, value}) do
        current_value - value
    end

     defp process(current_value, {:mul, value}) do
        current_value * value
    end

     defp process(current_value, {:div, value}) do
        current_value / value
    end



end

# (*) This is needed because the result of receive is stored in new_value, 
# which is then used as the server’s new state. By returning current_value, 
# you specify that the :value request doesn’t change the process state.

# TORUN:
# pid = StatefulCalculator.start()
# StatefulCalculator.value(pid)
# StatefulCalculator.add(pid, 10)
# StatefulCalculator.sub(pid, 3) 
# StatefulCalculator.mul(pid, 5)
# StatefulCalculator.value(pid)