import os, glob
import pandas as pd
import numpy as np

masterDir = os.path.dirname(__file__)

all_df = []

for root, dirs_list, files_list in os.walk(masterDir):
    for file_name in files_list:
        if os.path.splitext(file_name)[-2] + os.path.splitext(file_name)[-1] == "intensity.csv":
            file_name_path = os.path.join(root, file_name)
            with open(file_name_path, 'r') as csvfile:
                df = pd.read_csv(file_name_path, sep=',', index_col=False) 
                df.convert_dtypes() 

                df['Brain #'] = file_name_path.split('\\')[-2] 
                df["Brain region"] = df.apply(lambda row: row.Slice.split('-')[-1][0], axis = 1) 

                DATDorsalStriatum = (df.loc[df['Brain region'] == 'D', 'Mean']).mean() 
                DATVentralStriatum = (df.loc[df['Brain region'] == 'V', 'Mean']).mean() 

                THDorsalStriatum = (df.loc[df['Brain region'] == 'D', 'TH']).mean() 
                THVentralStriatum = (df.loc[df['Brain region'] == 'V', 'TH']).mean() 

                DATareaDorsalStriatum = df.loc[df['Brain region'] == 'D', '%Area'].mean()
                DATareaVentralStriatum = df.loc[df['Brain region'] == 'V', '%Area'].mean()
                THareaDorsalStriatum = df.loc[df['Brain region'] == 'D', 'TH Area'].mean()
                THareaVentralStriatum = df.loc[df['Brain region'] == 'V', 'TH Area'].mean()

                df['DAT intensity (dorsal striatum)'] = DATDorsalStriatum
                df['DAT intensity (ventral striatum)'] = DATVentralStriatum
                df['TH intensity (dorsal striatum)'] = THDorsalStriatum
                df['TH intensity (ventral striatum)'] = THVentralStriatum
                df['DAT area (dorsal striatum)'] = DATareaDorsalStriatum
                df['DAT area (ventral striatum)'] = DATareaVentralStriatum
                df['TH area (dorsal striatum)'] = THareaDorsalStriatum
                df['TH area (ventral striatum)'] = THareaVentralStriatum

                all_df.append(df)

df_merged = pd.concat(all_df, ignore_index=False, sort=True) 
df_merged = df_merged.reindex(columns=['Brain #', 'TH intensity (dorsal striatum)', 'TH intensity (ventral striatum)', 'DAT intensity (dorsal striatum)', 'DAT intensity (ventral striatum)', 'TH area (dorsal striatum)', 'TH area (ventral striatum)', 'DAT area (dorsal striatum)', 'DAT area (ventral striatum)'])
df_merged = df_merged.drop_duplicates() 
df_merged.to_excel(masterDir + "/compilation.xlsx", index=False) 
