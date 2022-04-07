from shutil import copy2
import os

optionals_list = []
mod_id_list = []

def whiteSpaceData(leading_up, line, follow=" "): #find number thats following the passed string in the passed line, follow is following characters
    data = line[line.find(leading_up)+len(leading_up):line.find(follow,line.find(leading_up)+len(leading_up))]
    return data

print('Please enter path to/drag preset file into here:')
path_2_file = input()
#clean up if user dragged file into entry and didn't enter path
if path_2_file.find(' ',0,5) > 0:
    path_2_file = path_2_file.replace(' ','',1)
if path_2_file[0] == '&':
    path_2_file = path_2_file.replace('&','',1)
if path_2_file[-1] == '\"' or path_2_file[-1] == '\'':
    path_2_file = path_2_file[:-1]
if path_2_file[0] == '\"' or path_2_file[0] == '\'':
    path_2_file = path_2_file[1:]
print(path_2_file)

with open(path_2_file, 'r') as file:
    for line in file:
        if (line.find("http://steamcommunity.com/sharedfiles")>0):
            mod_id = whiteSpaceData("?id=", line,'\"')
            print(mod_id)
            mod_id_list.append(mod_id)

print('Enter "yes" if these are your optional mods')
optional_true = input()
if (optional_true == 'yes'):
    optionals_list = mod_id_list
else:
    print('Closing script then...')
    exit()

print('Enter your mod staging directory:')
mod_staging = input()
#TODO deal with multiple server folders
#if you have entered all folders type in "done"etc
print('Enter your SERVER KEY FOLDER:')
path_2_keys_folder = input()

print('Copy keys now? (y/n)')
copy_keys = input()
if (copy_keys == 'y'):
    for mod in optionals_list:
        for root, dirs, files in os.walk(mod_staging + r'/' + mod):
            for file in files:
                if file.endswith('.bikey'):
                    print('copied'+file)
                    copy2(os.path.join(root, file), path_2_keys_folder)
else:
    print('Closing script then...')
    exit()