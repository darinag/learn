def fact(n):
    # Base case
    if n == 0:
        return 1

    else:
        return n * fact(n-1)

memo = {}
def fact_mome(n):
    if n < 2:
        return 1
    
    if n not in fact_mome:
        fact_mome[n] = n * fact_mome(k-1)

    return fact_mome[k] 

