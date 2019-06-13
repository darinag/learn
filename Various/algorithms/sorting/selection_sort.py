def selection(arr):

    lenArr = len(arr)

    for i in range(lenArr):
        minIndex = i

        for j in range (i+1, lenArr):
            if arr[j] < arr[minIndex]:
                minIndex = j

        arr[i], arr[minIndex] = arr[minIndex], arr[i]


arr = [1,6,8,2,5,3,8]
selection(arr)
print(arr)
