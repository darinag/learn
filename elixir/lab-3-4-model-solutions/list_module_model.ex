defmodule ListModule do
    def sum(lst), do: do_sum(lst, 0)
    defp do_sum([], acc), do: acc
    defp do_sum([h | t], acc), do: do_sum(t, acc + h)

    def len(lst), do: do_len(lst, 0)
    defp do_len([], res), do: res
    defp do_len([_ | t], res), do: do_len(t, res + 1)

    def reverse(lst), do: do_reverse(lst, [])
    def do_reverse([], res), do: res
    def do_reverse([h | t], res), do: do_reverse(t, [h] ++ res)

    # Non-tail-recursive version of span
    def span(from, to) when from > to, do: []
    def span(from, to), do: [from | span(from + 1, to)]

    # Tail-recursive version of span
    def span1(from, to), do: do_span(from, to, [])
    def do_span(from, to, res) when to < from, do: res
    def do_span(from, to, res), do: do_span(from, to-1, [to | res])

    # Non-tail-recursive flatten
    def flatten([]), do: []
    def flatten([h | t]), do: flatten(h) ++ flatten(t)
    def flatten(x), do: [x]

     # Tail-recursive flatten
    def flatten1(list), do: do_flatten(list, [])  
    defp do_flatten([],result), do: Enum.reverse(result)

    # The next two clauses deal with the head being a list:
    defp do_flatten([ [] | tail ], result), do: do_flatten(tail, result)  
    defp do_flatten([ [ h | [] ] | tail], result), do: do_flatten([ h | tail], result)  
    defp do_flatten([ [ h | t ] | tail], result), do: do_flatten([ h, t | tail], result)  

    # Otherwise the head is not a list, and we can collect it:  
    defp do_flatten([ head | tail ], result), do: do_flatten(tail, [ head | result ])  
    # End of tail-recursive flatten

end