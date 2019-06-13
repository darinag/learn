# https://en.wikipedia.org/wiki/Euclidean_algorithm#Worked_example

def gcdRecur(a, b):
    if b == 0:
        return a
    return gcdRecur(b, a%b)

def gcdIter(a, b):
    div = min(a, b)
       
    while a % div != 0 or b % div != 0:
        div -= 1
            
    return div
    