class Solution:
    # Write your code here
    #Two instance variables: one for your , and one for your .
    stack = []
    queue = []

    #A void pushCharacter(char ch) method that pushes a character onto a stack.
    def pushCharacter(self, ch):
        self.stack.append(ch)

    #A void enqueueCharacter(char ch) method that enqueues a character in the  instance variable.
    def enqueueCharacter(self, ch):
        self.queue.insert(0, ch)

    #A char popCharacter() method that pops and returns the character at the top of the  instance variable.
    def popCharacter(self):
        return self.stack.pop()
    #A char dequeueCharacter() method that dequeues and returns the first character in the  instance variable.
    def dequeueCharacter(self):
        return self.queue.pop()

# read the string s
s=input()
#Create the Solution class object
obj=Solution()   

l=len(s)
# push/enqueue all the characters of string s to stack
for i in range(l):
    obj.pushCharacter(s[i])
    obj.enqueueCharacter(s[i])
    
isPalindrome=True
'''
pop the top character from stack
dequeue the first character from queue
compare both the characters
''' 
for i in range(l // 2):
    if obj.popCharacter()!=obj.dequeueCharacter():
        isPalindrome=False
        break
#finally print whether string s is palindrome or not.
if isPalindrome:
    print("The word, "+s+", is a palindrome.")
else:
    print("The word, "+s+", is not a palindrome.")  