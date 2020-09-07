defmodule FrequencyTable do

    #    def update_freq(key, m)  do
    #         IO.puts('in update...')
    #         IO.puts(key)
    #         # IO.puts(m)
    #         # Map.update(map, key, initial, fun): if I want to increment a value

    #         # Map.put(map, key, value)
    #         curr_val = m[key]
    #         IO.puts(curr_val)
    #         Map.put(m, key, curr_val+1)
    #         IO.puts('done...')

    #         # key => value is for not atom keys
    #         # for atom keys: key: value
    #         # m = %{ m | key => m[key]+1 }
    #     end


    # def update_freq(key, m) when Map.has_key?(m, key) do
    #     # Map.update(map, key, initial, fun): if I want to increment a value

    #     # Map.put(map, key, value)
    #     # curr_val = m[key]
    #     # Map.put(m, key, curr_val+1)

    #     # key => value is for not atom keys
    #     # for atom keys: key: value
    #     m = %{ m | key => m[key]+1 }
    # end

    # def update_freq(key, m) when not Map.has_key?(m, key) do
    #     # Map.update(map, key, initial, fun): if I want to increment a value

    #     # Map.put(map, key, value)
    #     Map.put(m, key, 1)
    # end

    def update_freq(key, m) do
        if Map.has_key?(m, key) do  
            m = %{ m | key => m[key]+1 }
        else
            Map.put(m, key, 1) 
        end
    end

    def freq_count_body(list), do: freq_count_body(list, %{})
    def freq_count_body([h | t], map) when h == [], do: freq_count_body(update_freq(t, map), map)
    def freq_count_body([h | t], map), do: freq_count_body(t, update_freq(h, map))
    def freq_count_body([], map), do: map

    ## TODO
    # def freq_count_tail(list) do
    # end

    # TODO
    def freq_count_enum(list) do
        list |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    end

    def word_count(str) do
        str |>  String.downcase() |> String.replace("\n", "") |> String.replace("\r", "") |> String.replace(~r/\s+/, " ") |> String.trim() |> String.split(" ") |> freq_count_body()
    end

end