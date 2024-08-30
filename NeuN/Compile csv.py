import os, glob
import pandas as pd

masterDir = os.path.dirname(__file__)

all_df = []

for root, dirs_list, files_list in os.walk(masterDir):
    for file_name in files_list:
        if file_name == "NeuN-count.csv":
            file_name_path = os.path.join(root, file_name)
            with open(file_name_path, 'r') as csvfile:
                df = pd.read_csv(file_name_path, sep=',', index_col=False) 
                df.convert_dtypes() 

                df['Brain #'] = file_name_path.split('/')[-1].split('_')[-1].split('.')[0].split('\\')[-3]
                df["Brain region"] = df.apply(lambda row: row.Slice.split('-')[-1][0], axis = 1) 

                NeuNDorsalStriatum = df.loc[df['Brain region'] == 'D', 'Count'].sum() 
                NeuNVentralStriatum = df.loc[df['Brain region'] == 'V', 'Count'].sum() 
   
                DorsalStriatumImages = len(df.loc[df['Brain region'] == 'D', 'Count'])
                VentralStriatumImages = len(df.loc[df['Brain region'] == 'V', 'Count'])

                DorsalStriatumVolume = 0.21197*0.21197*DorsalStriatumImages # Area of the Dorsal Striatum in mm^2 (image is 211.97 x 211.97 um)
                VentralStriatumVolume = 0.21197*0.21197*VentralStriatumImages 
                
                NeuNDorsalStriatumDensity = NeuNDorsalStriatum / DorsalStriatumVolume
                NeuNVentralStriatumDensity = NeuNVentralStriatum / VentralStriatumVolume
                
                df['Number of NeuN in 1 mm^2 (dorsal striatum)'] = NeuNDorsalStriatumDensity
                df['Number of NeuN in 1 mm^2 (ventral striatum)'] = NeuNVentralStriatumDensity

                all_df.append(df)

df_merged = pd.concat(all_df, ignore_index=False, sort=True) 
df_merged = df_merged.reindex(columns=['Brain #', "Number of NeuN in 1 mm^2 (dorsal striatum)", "Number of NeuN in 1 mm^2 (ventral striatum)"]) 
df_merged = df_merged.drop_duplicates() 
df_merged.to_excel(masterDir + "/NeuN_count_compilation.xlsx", index=False) 