import math
import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.INFO)

with open("./2022/python/day-11/input.txt") as input:
    lines = input.read()

class Monkey:

    supermodulo = -1

    def __init__(self, monkey_info):

        parts = monkey_info.split("\n")
        self.name = int(parts[0].replace("Monkey ", "").replace(":", ""))
        self.items = [int(items.strip()) for items in parts[1].replace("  Starting items: ", "").split(",")]

        operation_parts = parts[2].replace("  Operation: new = old ", "").split(" ")
        self.operation =  operation_parts[0]
        self.operation_value = operation_parts[1]

        self.test_value = int(parts[3].replace("  Test: divisible by ", ""))
        self.true_monkey = int(parts[4].replace("    If true: throw to monkey ", ""))
        self.false_monkey = int(parts[5].replace("    If false: throw to monkey ", ""))

        self.inspection_count = 0

    def add_item(self, item):
        self.items.append(item)

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
            logging.debug(f"  Current worry level is divisible by {self.test_value}.")
            test_status = True
        else:
            logging.debug(f"  Current worry level is not divisible by {self.test_value}.")

        return test_status

    def inspect_items(self):
        for x in range(len(self.items)):
            item = self.items.pop(0)
            self.inspect_item(item)

    def inspect_item(self, item):
        self.increase_inspection_count()
        logging.debug(f"Monkey {self.name} is inspecting {item % self.supermodulo}")
        item = self.get_worry_level(item % self.supermodulo) 
        logging.debug(f"  Worry level is now {item}")
        if self.worry_level_test(item):
            self.throw_item(self.true_monkey, item)
        else:
            self.throw_item(self.false_monkey, item)

    def assign_partner(self, all_monkeys):
        self.true_monkey = all_monkeys[int(self.true_monkey)]
        self.false_monkey = all_monkeys[int(self.false_monkey)]

    def throw_item(self, monkey, item):
        logging.debug(f"  Item with worry level {item} is thrown to monkey {monkey.name}.")
        monkey.add_item(item)

def print_held_items(monkeys):
    for monkey in monkeys:
        print(f"Monkey {monkey.name} items: {monkey.items}")

monkeys_info = lines.split('\n\n')
monkeys = [Monkey(monkey_info) for monkey_info in monkeys_info]

Monkey.supermodulo = math.prod([monkey.test_value for monkey in monkeys])

for monkey in monkeys:
    monkey.assign_partner(monkeys)

rounds = 10000
for round in range(rounds):
    for monkey in monkeys:
        monkey.inspect_items()
    # print_held_items(monkeys)

for monkey in monkeys:
    print(f"Monkey {monkey.name} inspection count: {monkey.inspection_count}")

inspection_counts = [item.inspection_count for item in monkeys]

print(f"Figure out which monkeys to chase by counting how many items they inspect over {rounds} rounds. What is the level of monkey business after {rounds} rounds of stuff-slinging simian shenanigans? {math.prod(sorted(inspection_counts, reverse=True)[:2])}")