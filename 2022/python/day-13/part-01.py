import ast
import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

with open("./2022/python/day-13/input.txt") as input:
    lines = input.read()

packet_pairs = lines.split('\n\n')

class Packet: 
    def __init__(self, mylist):
        self.list = ast.literal_eval(mylist)

    def get_length(self):
        return len(self.list)

    def get_next_value(self):
        if len(self.list) == 0:
            return None
        else:
            return self.list.pop(0)

def compare_packets(left, right):
    logging.debug(f"Compare {left.list} vs {right.list}")
    while(left.get_length() != 0 and right.get_length() != 0):
        status = compare_values(left.get_next_value(), right.get_next_value())
        if (status == "equal"):
            continue
        else:
            return status 

    if (left.get_length() == 0):
        logging.debug(f"left list is exhausted - left: {left.list}; right: {right.list}")
        return "correct order"
    elif (right.get_length() == 0):
        logging.debug(f"right list is exhausted - left: {left.list}; right: {right.list}")
        return "incorrect order"

def compare_values(left, right):
    if type(left) is int and type(right) is int:
        logging.debug(f"compare two integers - left: {left}; right: {right}")
        return compare_integer(left, right)
    elif type(left) is list and type(right) is list:
        logging.debug(f"compare two lists - left: {left}; right: {right}")
        return compare_lists(left, right)
    elif type(left) is int and type(right) is list:
        logging.debug(f"mixed types - converting left into list - left: {left}; right: {right}")
        return compare_lists([left], right)
    elif type(left) is list and type(right) is int:
        logging.debug(f"mixed types - converting right into list - left: {left}; right: {right}")
        return compare_lists(left, [right])
    else:
        raise NotImplementedError("This case has not been covered")
        
def compare_integer(left, right):
    logging.debug(f"compare: {left} vs {right}")
    if left < right:
        return "correct order"
    elif left > right:
        return "incorrect order"
    else:
        return "equal"

def compare_lists(left, right):
    status = "equal"
    max = len(left) if len(left) > len(right) else len(right)
    for x in range(max):
        if x >= len(left):
            logging.debug(f"left list is exhausted - left: {left}; right: {right}")
            return "correct order"
        elif x >= len(right):
            logging.debug(f"right list is exhausted - left: {left}; right: {right}")
            return "incorrect order"

        status = compare_values(left[x], right[x])
        if status != "equal":
            return status
    
    return status

index = 1
index_sum = []
for packets in packet_pairs:
    pairs = packets.split("\n")
    left = Packet(pairs[0])
    right = Packet(pairs[1])
    if compare_packets(left, right) == "correct order":
        index_sum.append(index)
    index += 1
    print("")

print(f"Determine which pairs of packets are already in the right order. What is the sum of the indices of those pairs? {sum(index_sum)}")