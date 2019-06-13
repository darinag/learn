def isPalindrom(num):
    num = str(num)
    rev_num = num[::-1]
    return True if num == rev_num else False

def reverseNumber(num):
    num = str(num)
    num = num[::-1]
    num = int(num)
    return num

def f(num):
    count = 0
    sum = num + reverseNumber(num)

    while not isPalindrom(sum):
        sum = sum + reverseNumber(sum)
        count += 1
    else:
        count += 1
        print(sum, count)


# print(reverseNumber(1234))
# print(type(reverseNumber(1234)))
# print(isPalindrom(123))
# print(isPalindrom(12321))

# f(123)
# # f(187)
# f(155)







import sys

def containsEvenDigit(n):
     n = str(n)
     even = 0
     
     for i in n:
         if int(i) % 2 == 0:
             even += 1
                 
     if even != 0:
         return True
     else:
         return False

def reverseNumber(num):
    num = str(num)
    num = num[::-1]
    num = int(num)
    return num

def f(num):
    count = 0
    sum = num + reverseNumber(num)
    
    while containsEvenDigit(sum):
        sum = sum + reverseNumber(sum)
        count += 1
        
    else:
        count += 1
        print(count, sum)


for line in sys.stdin:
    f(int(line))
 








