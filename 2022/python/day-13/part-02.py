import ast, math
import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.INFO)

import time
start_time = time.time()

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


def bubbleSort(arr):
    n = len(arr)
 
    # Traverse through all array elements
    for i in range(n):
 
        # Last i elements are already in place
        for j in range(0, n-i-1):
 
            # traverse the array from 0 to n-i-1
            # Swap if the element found is greater
            # than the next element
            # if arr[j] > arr[j+1]:
            if compare_packets(Packet(arr[j]), Packet(arr[j+1])) != "correct order":
                logging.debug("swap packet location")
                arr[j], arr[j+1] = arr[j+1], arr[j]

def mergeSort(arr):
    if len(arr) > 1:
 
         # Finding the mid of the array
        mid = len(arr)//2
 
        # Dividing the array elements
        L = arr[:mid]
 
        # into 2 halves
        R = arr[mid:]
 
        # Sorting the first half
        mergeSort(L)
 
        # Sorting the second half
        mergeSort(R)
 
        i = j = k = 0
 
        # Copy data to temp arrays L[] and R[]
        while i < len(L) and j < len(R):
            # if L[i] <= R[j]:
            if compare_packets(Packet(L[i]), Packet(R[j])) == "correct order":
                arr[k] = L[i]
                i += 1
            else:
                arr[k] = R[j]
                j += 1
            k += 1
 
        # Checking if any element was left
        while i < len(L):
            arr[k] = L[i]
            i += 1
            k += 1
 
        while j < len(R):
            arr[k] = R[j]
            j += 1
            k += 1

all_packets = []
for packets in packet_pairs:
    pairs = packets.split("\n")
    all_packets.append(pairs[0])
    all_packets.append(pairs[1])

# add divider packets
all_packets.append("[[2]]")
all_packets.append("[[6]]")

# bubbleSort(all_packets)  # execution time for full script: 7.35 seconds
mergeSort(all_packets) # execution time for full script: .425 seconds

divider_indexes = []
for i in range(len(all_packets)):
    if (all_packets[i] in ("[[2]]", "[[6]]")):
        divider_indexes.append(i + 1)
    print(all_packets[i])

print(f"Organize all of the packets into the correct order. What is the decoder key for the distress signal? {math.prod(divider_indexes)}")

print("--- %s seconds ---" % (time.time() - start_time))