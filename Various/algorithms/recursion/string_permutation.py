# L = ['apples', 'bananas', 'oranges']
# for idx, val in enumerate(L):
#   print("index is %d and value is %s" % (idx, val))

#   # index is 0 and value is apples
#   # index is 1 and value is bananas
#   # index is 2 and value is oranges

# str = "Python"
# for idx, ch in enumerate(str):
#   print("index is %d and character is %s" \
#          % (idx, ch))

def permute(s):
    
    out = []

    # base case
    if len(s) <= 1:
        out = [s]

    else:
          # For every letter in string
        for i, letter in enumerate(s):
            
            # For every permutation resulting from Step 2 and 3 described above
            for perm in permute(s[:i] + s[i+1:]):

                print('Current letter is ', letter)
                print('Perm is ', perm)
                
                # Add it to output
                out += [letter + perm]
                print('Out is: ', out)

    return out

print(permute('123'))


