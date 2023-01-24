input = open("./2022/python/day-06/input.txt")

signal = input.readline()

counter, marker_length = 0, 14

while counter <= len(signal):
    if len(set(signal[counter: counter + 1 + marker_length - 1])) >= marker_length:
        break
    counter += 1

print(f"How many characters need to be processed before the first start-of-message marker is detected? {counter + marker_length}")