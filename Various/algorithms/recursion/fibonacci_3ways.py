def fib_iter(n):
    
    # Set starting point
    # a = 0
    # b = 1
    a, b = 0, 1
    
    # Follow algorithm
    for i in range(n):
        
        a, b = b, a + b
        print('A is', a)
        print('B is ', b)
        
    return a


def fib_rec(n):
    if n <= 1:
        return n
    else:
        return fib_rec(n - 1) + fib_rec(n - 2)


cache = {}
def fib_memo(n):
    if n <= 1:
        return n
    
    if n in cache:
        return cache[n]

    else:
        value = fib_memo(n-1) + fib_memo(n-2)
        cache[n] = value
        return value


# Instantiate Cache information
n = 10
cache = [None] * (n + 1)


def fib_dyn(n):
    
    # Base Case
    if n == 0 or n == 1:
        return n
    
    # Check cache
    if cache[n] != None:
        return cache[n]
    
    # Keep setting cache
    cache[n] = fib_dyn(n-1) + fib_dyn(n-2)
    
    return cache[n]


