class Queue:
    def __init__(self):
        self.queue = []

    def enqueue(self, val):
        return self.queue.insert(0, val)

    def dequeue(self):
        if self.is_empty():
            return None
        else:
            self.queue.pop()

    def size(self):
        return len(self.queue)

    def is_empty(self):
        return self.size() == 0


q = Queue()
q.enqueue(1)
q.enqueue(2)
q.enqueue(3)
q.enqueue(4)
print(q.size())
q.dequeue()
print(q.size())




        
