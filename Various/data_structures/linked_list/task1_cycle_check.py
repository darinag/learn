class Node():
    def __init__(self, value):
        self.value = value
        self.nextnode = None

# Floyd's cycle finding algorithm
def cycle_check(node):

    # Begin both markers at the first node
    marker1 = node
    marker2 = node

    # Go until end of list
    while marker2 != None and marker2.nextnode != None:
        
        # Note
        marker1 = marker1.nextnode
        marker2 = marker2.nextnode.nextnode

        # Check if the markers have matched
        if marker2 == marker1:
            return True

    # Case where marker ahead reaches the end of the list
    return False



def detectLoop(self): 
        s = set() 
        temp=self.head 
        while (temp): 
        
            # If we have already has 
            # this node in hashmap it 
            # means their is a cycle 
            # (Because you we encountering 
            # the node second time). 
        if (temp in s): 
            return True
    
        # If we are seeing the node for 
        # the first time, insert it in hash 
        s.add(temp) 
    
        temp = temp.next
        
    
        return False

"""
RUN THIS CELL TO TEST YOUR SOLUTION
"""
from nose.tools import assert_equal

# CREATE CYCLE LIST
a = Node(1)
b = Node(2)
c = Node(3)

a.nextnode = b
b.nextnode = c
c.nextnode = a # Cycle Here!


# CREATE NON CYCLE LIST
x = Node(1)
y = Node(2)
z = Node(3)

x.nextnode = y
y.nextnode = z


#############
class TestCycleCheck(object):
    
    def test(self,sol):
        assert_equal(sol(a),True)
        assert_equal(sol(x),False)
        
        print("ALL TEST CASES PASSED")
        
# Run Tests

t = TestCycleCheck()
t.test(cycle_check)

