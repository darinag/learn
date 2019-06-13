def binary_search_iterative(arr, ele):

    first = 0
    last = len(arr) - 1

    found = False

    while first <= last and not found:
        mid = (first+last)/2

        if arr[mid] == ele:
            found = True
        
        else:
            if ele < arr[mid]:
                last = mid - 1
            else:
                first = mid + 1

    return found


def binary_search_rec(arr, ele):

    if len(arr) == 0:
        return False

    else:
        mid = len(arr)/2

        if arr[mid] == ele:
            return True

        else:
            if ele < arr[mid]:
                return binary_search_rec(arr[:mid], el])

            else:
                return binary_search_rec(arr[mid+1], ele)



binary_search_iterative( )