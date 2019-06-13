### SEQUENCIAL SEARCH ###

def seq_search(arr, element):
    position = 0
    found = False

    while position < len(arr) and not found:

        if arr[position] == element:
            found = True

        else:
            position += 1

    return found


def sorted_seq_search(arr, element):
    position = 0
    found = False
    stopped = False

    while position < len(arr) and not found and not stopped:

        if arr[position] == element:
            found = True

        else:
            if arr[position] > element:
                stopped = True

            else:
                position += 1

    return found

