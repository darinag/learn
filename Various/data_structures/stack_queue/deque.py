class Deque:
    def __init__(self):
        self.dq = []

    def isEmpty(self):
        return self.dq == []

    def addFront(self, item):
        self.dq.append(item)

    def addRear(self, item):
        self.dq.insert(0, item)

    def removeFront(self):
        return self.dq.pop()

    def removeRear(self):
        return self.dq.pop(0)

    def size(self):
        return len(self.dq)

