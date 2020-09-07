defmodule Powers do 

    def square(n) do
        n*n
    end

    def pow(n, 1) do
        n
    end

    def pow(n, exp) do 
        n*pow(n, exp-1)
    end

    def cube(n) do
        pow(n, 3)
    end

    # def square_or_cube(n, 2) do
    #     square(n)
    # end

    #  def square_or_cube(n, 3) do
    #     cube(n)
    # end

    def square_or_cube(n, exp) when exp==2 do
        square(n)
    end

    def square_or_cube(n, exp) when exp==3 do
        cube(n)
    end

    def square_or_cube(_, _) do
        :error
    end

    def pow2(n, exp) when exp==0 do
        1
    end

    def pow2(n, exp) when exp>=1 do
        n*pow2(n, exp-1)
    end



end