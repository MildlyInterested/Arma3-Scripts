import tkinter as tk

root = tk.Tk()

list_1_var=tk.StringVar()
list_2_var=tk.StringVar()

# compare difference between two lists and output the diff
def get_diff():
    display_optionals.delete(0, tk.END)
    list_1 = list_1_var.get().split(',')
    list_2 = list_2_var.get().split(',')
    diff = set(list_1) ^ set(list_2)
    if len(diff)==0:
        diff = 'No differences found!'
    else:
        diff_str='['+str(diff).strip('{}').replace(' ','').replace('"','')+']'
        display_optionals.insert(0, diff_str)
    
    

#TEXT
info_text_1 = '1. execute "copyToClipboard str ("true" configClasses (configFile >> "CfgPatches") apply {configName _x});" locally in the editor'
info_text_2 = '2. CTRL+V in the following boxes (may freeze for a second)'
mod_1_text = 'Loaded addons no 1'
mod_2_text = 'Loaded addons no 2'

#GUI
root.title('Mildly_Interested')
window_label = tk.Label(root, text = "Mod Whitelisting Utility", font=('Arial', 14)).grid(row=0, columnspan=2)

info_1 = tk.Label(root, text=info_text_1).grid(row=1, column=0, columnspan=2)
info_2 = tk.Label(root, text=info_text_2).grid(row=2, column=0, columnspan= 2)

mod_1 = tk.Label(root, text=mod_1_text).grid(row=3, column=0)
input_mod_list_1 = tk.Entry(root, textvariable=list_1_var).grid(row=3, column=1)

mod_2 = tk.Label(root, text=mod_2_text).grid(row=4, column=0)
input_mod_list_2 = tk.Entry(root, textvariable=list_2_var).grid(row=4, column=1)

tk.Button(text='Find Difference', command=get_diff).grid(row=5, column=1)

optionals_1 = tk.Label(root, text='Optional addons:').grid(row=6, column=0)
display_optionals = tk.Entry(root)
display_optionals.grid(row=6, column= 1)
display_optionals.insert(0, 'No differences found!')

root.mainloop()