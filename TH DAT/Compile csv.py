import os, glob
import pandas as pd
import numpy as np

masterDir = os.path.dirname(__file__)

all_df = []

for root, dirs_list, files_list in os.walk(masterDir):
    for file_name in files_list:
        if os.path.splitext(file_name)[-2] + os.path.splitext(file_name)[-1] == "intensity-whole-img.csv":
            file_name_path = os.path.join(root, file_name)
            with open(file_name_path, 'r') as csvfile:
                df = pd.read_csv(file_name_path, sep=',', index_col=False) 
                df.convert_dtypes() 

                df['Brain #'] = file_name_path.split('\\')[-2] # Cleanup the path to extract the brain number for windows
                #df['Brain #'] = file_name_path.split('/')[-2] # Cleanup the path to extract the brain number for mac

                df["Brain region"] = df.apply(lambda row: row.Slice.split('-')[-1][0], axis = 1) 

                DATDorsalStriatum = (df.loc[df['Brain region'] == 'D', 'Mean']).mean() 
                DATVentralStriatum = (df.loc[df['Brain region'] == 'V', 'Mean']).mean() 

                THDorsalStriatum = (df.loc[df['Brain region'] == 'D', 'TH']).mean() 
                THVentralStriatum = (df.loc[df['Brain region'] == 'V', 'TH']).mean() 

                df['DAT MFI (dorsal striatum)'] = DATDorsalStriatum
                df['DAT MFI (ventral striatum)'] = DATVentralStriatum
                df['TH MFI (dorsal striatum)'] = THDorsalStriatum
                df['TH MFI (ventral striatum)'] = THVentralStriatum

                all_df.append(df)

df_merged = pd.concat(all_df, ignore_index=False, sort=True)
df_merged = df_merged.reindex(columns=['Brain #', 'TH MFI (dorsal striatum)', 'TH MFI (ventral striatum)', 'DAT MFI (dorsal striatum)', 'DAT MFI (ventral striatum)']) 
df_merged = df_merged.drop_duplicates() 
df_merged.to_excel(masterDir + "/compilation-whole-img.xlsx", index=False) 