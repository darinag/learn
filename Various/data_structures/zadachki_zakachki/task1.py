test1 = [5, 1, 7, 10, 5, 5, 1000, 99, 1]
test2 = [0]
test3 = [9,9,9,9,9,9,9,9,1]
test4 = [1,9,9,9,9,9,9,9]

def remove_dublicates(arr):
    table = {}
    res = []

    for item in arr:
        if item not in table:
            table[item] = False
        else:
            table[item] = True

    # for item in arr:
    #     if table[item] is False:
    #         res.append(item)

    return [ item for item in arr if table[item] is False ]

        
assert(remove_dublicates(test1) == [7,10,1000,99])
assert(remove_dublicates(test2) == [0])
assert(remove_dublicates(test3) == [1])
assert(remove_dublicates(test4) == [1])