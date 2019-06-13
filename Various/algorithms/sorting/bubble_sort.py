def bubbleSort(arr):
    n = len(arr)
 
    # Traverse through all array elements
    for i in range(n):
 
        # Last i elements are already in place
        for j in range(n-1):
 
            # traverse the array from 0 to n-i-1
            # Swap if the element found is greater
            # than the next element
            if arr[j] > arr[j+1] :
                arr[j], arr[j+1] = arr[j+1], arr[j]

# Driver code to test above
arr = [64, 34, 25, 12, 22, 11, 90]
# arr = ['A', 'm', 'a', 'B', 'b'] 
 
bubbleSort(arr)
 
print ("Sorted array is:")
for i in range(len(arr)):
    print (arr[i]), 


def bubble_sort(str):
    n = len(str)
    for i in range(n):
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]


str = 'string'
stringCharacters = []
for i in str:
    stringCharacters.append(i)

print(stringCharacters)
bubble_sort(stringCharacters)


for i in range(len(stringCharacters)):
    print(stringCharacters[i])
