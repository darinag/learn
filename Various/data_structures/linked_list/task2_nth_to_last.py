class Node():
    def __init__(self, value):
        self.value = value
        self.nextnode = None 

# Walk one pointer n nodes from the head, this will be the right_point
# Put the other pointer at the head, this will be the left_point
# Walk/traverse the block (both pointers) towards the tail, one node at a time, keeping a distance n between them.
# Once the right_point has hit the tail, we know that the left point is at the target.

def nth_to_last_node(n, head):

    leftPtr = head
    rightPtr = head

    for i in range(n-1):

        if not rightPtr.nextnode:
            raise LookupError('Error: n is larger than the linked list.')

        rightPtr = rightPtr.nextnode

    while rightPtr.nextnode:
        leftPtr = leftPtr.nextnode
        rightPtr = rightPtr.nextnode

    return leftPtr

"""
RUN THIS CELL TO TEST YOUR SOLUTION AGAINST A TEST CASE 

PLEASE NOTE THIS IS JUST ONE CASE
"""

from nose.tools import assert_equal

a = Node(1)
b = Node(2)
c = Node(3)
d = Node(4)
e = Node(5)

a.nextnode = b
b.nextnode = c
c.nextnode = d
d.nextnode = e

####

class TestNLast(object):
    
    def test(self,sol):
        
        assert_equal(sol(2,a),d)
        print('ALL TEST CASES PASSED')
        
# Run tests
t = TestNLast()
t.test(nth_to_last_node)

