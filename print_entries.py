import json
import ast
import pandas as pd
f = open("MovieData.txt", "r")
file1 = f.read()
file_list = ast.literal_eval(file1)
with open('movieData.json','w') as s:
    json.dump(file_list, s)
dataset = pd.read_json('movieData.json')
print(dataset.head(5))

