defmodule FloodingTest do

    defp sync(msg, n) do 
        for _ <- 1..n do
            receive do
                ^msg -> :ok
            end
        end
    end

    def test() do
        procs = [
            spawn(FloodingTest, :run, [:p1, [:p2, :p3], self]),
            spawn(FloodingTest, :run, [:p2, [:p1, :p3], self]),
            spawn(FloodingTest, :run, [:p3, [:p2, :p1], self])
        ]
        sync(:ready, 3)
        for p <- procs, do: send(p, :start)
        sync(:done, 3)
    end

    def run(name, neighbours, p) do
        pid = FloodingBC.start(name, neighbours, self)
        send(p, :ready)
        receive do 
            :start -> 
                IO.puts("#{inspect name} started")
                FloodingBC.bc_send(pid, "Hello from #{name}")
                for _ <- 1..3 do 
                    receive do
                        msg -> IO.puts("#{name} received #{inspect msg}")
                    end
                end
        end
        send(p, :done)
    end
end