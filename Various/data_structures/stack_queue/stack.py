class Stack:
    def __init__(self):
        self.stack = []

    def pop(self):
        if self.is_empty():
            return None
        else:
            return self.stack.pop()

    def push(self, val):
            return self.stack.append(val)

    # returns the last element of s stack
    def peak(self):
        if self.is_empty():
            return None
        else:
            return self.stack[-1]

    def size(self):
        return len(self.stack)

    def is_empty(self):
        return self.size() == 0

s = Stack()
s.push(4)
s.push(3)
s.push(2)
print(s.size())
s.pop()
print(s.size())
print(s.pop())

    
