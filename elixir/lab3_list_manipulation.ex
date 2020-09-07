defmodule ListModule do
    def sum_square([]), do: 0
    def sum_square([h | t]), do: h*h + sum_square(t)
    
    def len([]), do: 0
    def len([h | t]), do: 1 + len(t)
    
    # Note ++ is very expensive operation. 
    def reverse([]), do: []
    def reverse([h | t]), do: reverse(t) ++ [h]
    # or use Enum.reverse(list)

    def sum([]), do: 0
    def sum([h | t]), do: h + sum(t)

    def span(from, to) when from > to, do: []
    def span(from, to) when from <= to, do: [from | span(from+1, to)] 

end

# list = List.duplicate(0, 5) |> List.duplicate(5) 
defmodule FlattenReverse do
  def flatten(list), do: flatten(list, []) |> Enum.reverse
  def flatten([h | t], acc) when h == [], do: flatten(t, acc)
  def flatten([h | t], acc) when is_list(h), do: flatten(t, flatten(h, acc))
  def flatten([h | t], acc), do: flatten(t, [h | acc])
  def flatten([], acc), do: acc
end

defmodule FlattenAppend do
  def flatten(list), do: flatten(list, [])
  def flatten([h | t], acc) when h == [], do: flatten(t, acc)
  def flatten([h | t], acc) when is_list(h), do: flatten(t, flatten(h, acc))
  def flatten([h | t], acc), do: flatten(t, acc ++ [h])
  def flatten([], acc), do: acc
end

# list = List.duplicate(0, 200) |> List.duplicate(200)

# {time, _} = :timer.tc fn -> FlattenReverse.flatten(list) end
# IO.puts "Flatten reverse took #{time}"

# {time, _} = :timer.tc fn -> FlattenAppend.flatten(list) end
# IO.puts "Flatten append took #{time}"