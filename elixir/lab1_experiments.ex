IO.puts("Hello, world!")
inp = IO.gets("Please enter something: ")
inp
String.trim(inp)
name = "Greg"
IO.puts("Hello, #{name}! 2 + 2 is #{2 + 2}")
IO.puts("Hello, " <> name <> "!")
IO.puts(~s{"Hello", } <> name <> "!")

IO.puts("Hello World!")

inp = IO.gets("Please enter something: ")
trimmed = String.trim(inp)
IO.puts(trimmed)

name = "Nick"
IO.puts("Hello #{name}! Is 2+2 equal to #{2+3}")
IO.puts("Hello " <>name<> " - whats up?")


x = 5
y = 12.3
z = x + y
x
y
z
x = 5/2
y = div(5, 2)
i x
i y
rem(5, 2)
x = 5 - 3 * 6 + (14 - 2)
x
Integer.to_string(23)

true & false
true or false
1 == 1 and 2 != 1
1 == 1 and not(2 == 1)
125 and true
125 && true
(1 == 1 and 2 > 1) && (div(5,2) >= 0)

{x, y} = {5, 6}
x
y
{5, 6} = {x, y}
i {x, y}
i x
{x, y} = {y, x}
x
y
Integer.parse("23")
{x, _} = Integer.parse("23")
x

lst = [1, 2, 3, 4]
[h | t] = lst
h
t
i lst
lst = [:abc | lst]
hd(lst)
tl(lst)
lst ++ [:x, :y, "abc"]

a = 1
a
1 = a
2 = a
lst = [1, 2, 3]
[a, b, c] = lst
a
b
c
[a, 2, b] = [1, 2, 3]
a
b
[a, b, a] = [1, 4, 1]
a
b
[a, b, a] = [1, 4, 3]
a = 1
^a = 1
^a = 2