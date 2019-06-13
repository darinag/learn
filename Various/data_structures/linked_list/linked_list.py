class ListNode:
    def __init__(self, data):
        self.data = data
        self.next = None

    def has_value(self, value):
        if self.data == value:
            return True
        else:
            return False

class SingleLinkedList:
    # initiate an object
    def __init__(self):
        self.head = None
        self.tail = None
        return

    def add_list_item(self, item):
        "add an list item at the end of the list"

        if not isinstance(item, ListNode):
            item = ListNode(item)

        if self.head is None:
            self.head = item
        else: 
            self.tail.next = item

        self.tail = item

        return

    def list_length(self):
        count = 0
        current_node = self.head

        while current_node is not None:
            count += 1
            current_node = current_node.next

        return count


    def output_list(self):

        current_node = self.head

        while current_node is not None:
            print(current_node.data)
            current_node = current_node.next

    def unordered_search(self, value):
        current_node = self.head

        node_id = 1

        results = []

        while current_node is not None:
            if current_node.has_value(value):
                results.append(node_id)

            current_node = current_node.next
            node_id += 1

        return results

    # https://www.pythoncentral.io/find-remove-node-linked-lists/
    def remove_list_item_by_id(self, item_id):

        current_id = 1

        # have 2 pointers:
        current_node = self.head # initially points to head
        previous_node = None # initially point to None

        while current_node is not None:
            if current_id == item_id:

                if previous_node is not None:
                    previous_node.next = current_node.next
                
                else:
                    self.head = current_node.next
                    return

            previous_node = current_node
            current_node = current_node.next
            current_id += 1
    
    
node1 = ListNode(15)
node2 = ListNode(8.2)
node3 = "Berlin"
node4 = ListNode(15)

track = SingleLinkedList()
print("track lenght: ", track.list_length())

for current_item in [node1, node2, node3, node4]:
    track.add_list_item(current_item)
    print("track length: ", track.list_length())
    track.output_list()

print("Is there 15 in any of the Nodes??", track.unordered_search(15)) 