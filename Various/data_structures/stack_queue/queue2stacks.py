class Queue2Stacks():

    def __init__(self):
        self.instack = []
        self.outstack = []

    def enqueue(self, element):
        self.instack.append(element)

    def dequeue(self):

        if not self.outstack:
            # while we have element in instack do the following
            while self.instack:
                popped = self.instack.pop()
                self.outstack.append(popped)
        return self.outstack.pop()

"""
RUN THIS CELL TO CHECK THAT YOUR SOLUTION OUTPUT MAKES SENSE AND BEHAVES AS A QUEUE
"""
q = Queue2Stacks()

for i in xrange(5):
    q.enqueue(i)
    
for i in xrange(5):
    print q.dequeue()