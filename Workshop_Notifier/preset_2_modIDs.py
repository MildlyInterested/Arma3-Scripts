import re

pattern = re.compile("\?id=[0-9]+")
dirty_list = []
clean_numbers = []

with open ('preset.html', mode='rt', errors='replace') as myfile:    
    for line in myfile:
        if pattern.search(line) != None:
            dirty_numbers = re.findall("[0-9]+", line)
            dirty_numbers_unique = set(dirty_numbers)
            dirty_list.append(dirty_numbers_unique)

dirty_string = str(dirty_list)
clean_numbers = re.sub(r"[\[\]\'\s\{\}]", '',dirty_string)
print(clean_numbers)