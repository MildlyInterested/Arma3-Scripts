def whiteSpaceData(leading_up, line, follow=" "): #find number thats following the passed string in the passed line, follow is following characters
    data = line[line.find(leading_up)+len(leading_up):line.find(follow,line.find(leading_up)+len(leading_up))]
    return data

mod_id_list = []

print('Please enter path to/drag preset file into here:')
path_2_file = input()
if path_2_file[0] == '&':
    path_2_file = path_2_file[3:]
    path_2_file = path_2_file[:-1]
print(path_2_file)

with open(path_2_file, 'r') as file:
    for line in file:
        if (line.find("http://steamcommunity.com/sharedfiles")>0):
            mod_id = whiteSpaceData("?id=", line,'\"')
            #print(mod_id)
            mod_id_list.append(mod_id)

mod_str = ','.join(mod_id_list)
print(mod_str)