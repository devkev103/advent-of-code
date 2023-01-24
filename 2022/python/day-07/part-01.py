with open("./2022/python/day-07/input.txt") as input:
     lines = input.readlines()

counter = 0
total_lines = len(lines)

current_directory = []
directory_listing = []
directory_structure = []

def parse_file(file):
    parts = file.split(' ')
    return {"filename": parts[1], "size": int(parts[0])}

while counter < total_lines:
    if lines[counter].startswith("$ cd"):
        if(lines[counter].strip() == "$ cd .."):
            current_directory.pop()
        else:
            current_directory.append(lines[counter].strip().split(' ')[2])
        counter += 1
    elif lines[counter].startswith('$ ls'):
        counter += 1
        while counter < total_lines and not lines[counter].startswith('$'):
            directory_listing.append(lines[counter].strip())
            counter += 1

        directory_path = '/'.join([directory for directory in current_directory])[1:] + "/"
        directories = [(directory_path + dir.replace('dir ', '') + "/") for dir in directory_listing if dir.startswith('dir')]
        files = [parse_file(file) for file in directory_listing if not file.startswith('dir')]
        total_size = sum([file['size'] for file in files])
        directory_structure.append({"directory_path": directory_path, "contains_directories": directories, "files": files, "total_directory_size": int(total_size)})
        directory_listing.clear()
    else:
        print("SHOULD NEVER HAPPEN")

print(directory_structure)


def get_sub_directory(directory_path) -> int:
    total = 0
    for directory in directory_structure:
        if directory['directory_path'] == directory_path:
            total += directory['total_directory_size']
            print(f"  total of {directory['directory_path']}: {total}")
            if directory['contains_directories']:
                for sub_directory in directory['contains_directories']:
                    total += get_sub_directory(sub_directory)

    return total

directory_totals = []

for directory in directory_structure:
    print(f"totaling directory: {directory['directory_path']}")
    total = directory["total_directory_size"]
    print(f"  total of {directory['directory_path']}: {total}")
    # if total < 100000: # optimization
    for sub_directory in directory['contains_directories']:
        total += get_sub_directory(sub_directory)
    print(f"  full total directory_path {directory['directory_path']} : {total}")
    directory_totals.append({"directory_path": directory['directory_path'], "total_size": total})
    print('')

total = sum([directory["total_size"] for directory in directory_totals if directory["total_size"] <= 100000])

print(f'Find all of the directories with a total size of at most 100000. What is the sum of the total sizes of those directories? {total}')