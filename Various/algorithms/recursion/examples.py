# if n=4 , return 4+3+2+1+0, which is 10.
def recursion_sum(n):
    if n == 1:
        return 1
    else:
        # print(n + (n-1)) 
        return n + recursion_sum(n-1)

print(recursion_sum(4))


# if n = 4321, return 4+3+2+1
def sum_func(n):
       # Base case, cast the digit to a string
    if len(str(n)) == 1:
        return n
    
    # Recursion
    else:
        return n%10 + sum_func(n/10)


# The function will then determine if it is possible to split 
# the string in a way in which words can be made from the list 
# of words. You can assume the phrase will only contain words 
# found in the dictionary if it is completely splittable.
def word_split(phrase,list_of_words, output = None):

 # Checks to see if any output has been initiated.
    # If you default output=[], it would be overwritten for every recursion!
    if output is None:
        output = []
    
    # For every word in list
    for word in list_of_words:
        
        # If the current phrase begins with the word, we have a split point!
        if phrase.startswith(word):
            
            # Add the word to the output
            output.append(word)
            
            # Recursively call the split function on the remaining portion of the phrase--- phrase[len(word):]
            # Remember to pass along the output and list of words
            return word_split(phrase[len(word):],list_of_words,output)
    
    # Finally return output if no phrase.startswith(word) returns True
    return output



