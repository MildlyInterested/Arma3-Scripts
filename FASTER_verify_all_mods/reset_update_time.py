from shutil import copy2
import xml.etree.ElementTree as ET

print('Please enter path to/drag preset file into here:')
# path_2_file = input()
path_2_file = "C:\\Users\\Manuel\\AppData\\Local\\FoxliCorp\\FASTER_StrongName_r3kmcr0zqf35dnhwrlga5cvn2azjfziz\\1.8.5.1\\user.config"

tree = ET.parse(path_2_file)
root = tree.getroot()

for LocalLastUpdated in root.iter('LocalLastUpdated'):
    if int(LocalLastUpdated.text) > 0:
        LocalLastUpdated.text = str(0)
        print(LocalLastUpdated.text)
        
tree.write(path_2_file)