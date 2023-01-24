import math

with open("./2022/python/day-11/input.txt") as input:
    lines = input.read()

class Monkey:

    def __init__(self, monkey_info):
        parts = monkey_info.split("\n")
        self.name = int(parts[0].replace("Monkey ", "").replace(":", ""))
        self.items = [int(items.strip()) for items in parts[1].replace("  Starting items: ", "").split(",")]

        operation_parts = parts[2].replace("  Operation: new = old ", "").split(" ")
        self.operation =  operation_parts[0]
        self.operation_value = operation_parts[1]

        self.test_value = int(parts[3].replace("  Test: divisible by ", ""))
        self.test_true = int(parts[4].replace("    If true: throw to monkey ", ""))
        self.test_false = int(parts[5].replace("    If false: throw to monkey ", ""))

        self.inspection_count = 0
        self.current_item = -1
        self.current_worry_level = -1
        self.test_status = False

    def add_item(self, item):
        self.items.append(item)

    def remove_item(self):
        self.items.remove(self.current_item)

    def increase_inspection_count(self):
        self.inspection_count += 1

    def get_worry_level(self, item) -> int:
        worry_level = 0
        if self.operation == "+" and self.operation_value != "old":
            worry_level = item + int(self.operation_value)
        elif self.operation == "*" and self.operation_value != "old":
            worry_level = item * int(self.operation_value)
        elif self.operation == "+" and self.operation_value == "old":
            worry_level = item + item
        elif self.operation == "*" and self.operation_value == "old":
            worry_level = item * item
        else:
            raise NotImplementedError("This operation is not yet implemented")

        return worry_level
    
    def worry_level_test(self, worry_level) -> bool:
        test_status = False
        if worry_level % self.test_value == 0:
            print(f"  Current worry level is divisible by {self.test_value}.")
            test_status = True
        else:
            print(f"  Current worry level is not divisible by {self.test_value}.")

        return test_status

    def get_receiving_monkey(self) -> int:
        if self.test_status:
            return self.test_true
        else:
            return self.test_false

    def inspect_item(self, item):
        self.increase_inspection_count()
        self.current_item = item
        print(f"Monkey {self.name} is inspecting {self.current_item}")
        self.current_worry_level = self.get_worry_level(self.current_item) 
        print(f"  Worry level is now {self.current_worry_level}")
        self.current_worry_level = math.floor(self.current_worry_level / 3)
        print(f"  Monkey gets bored with item. Worry level is divided by 3 to {self.current_worry_level}.")
        self.test_status = self.worry_level_test(self.current_worry_level)

def throw_item(giver: Monkey, receiver: Monkey):
    print(f"  Item with worry level {giver.current_worry_level} is thrown to monkey {receiver.name}.")
    giver.remove_item()
    receiver.add_item(giver.current_worry_level)

def print_held_items(monkeys):
    for monkey in monkeys:
        print(f"Monkey {monkey.name} items: {monkey.items}")

monkeys_info = lines.split('\n\n')
monkeys = [Monkey(monkey_info) for monkey_info in monkeys_info]

for round in range(20):
    for monkey in monkeys:
        for item in monkey.items[:]: # The [:] returns a "slice" of x, which happens to contain all its elements, and is thus effectively a copy of x.
            monkey.inspect_item(item)
            throw_item(monkey, monkeys[monkey.get_receiving_monkey()])
    print_held_items(monkeys)

for monkey in monkeys:
    print(f"Monkey {monkey.name} inspection count: {monkey.inspection_count}")

inspection_counts = [item.inspection_count for item in monkeys]

print(f"Figure out which monkeys to chase by counting how many items they inspect over 20 rounds. What is the level of monkey business after 20 rounds of stuff-slinging simian shenanigans? {math.prod(sorted(inspection_counts, reverse=True)[:2])}")