s = 'almbegghakl'

longest_substr = s[0]
current = s[0]

for i in range(1, len(s)):
    if s[i] >= current[-1]:
        current += s[i]

        if len(longest_substr) < len(current):
            longest_substr = current
    else:
        current = s[i]
print(f"Longest substring in alphabetical order is: {longest_substr}")
# ans = beggh

