#!/usr/bin/env python

import pandas as pd
import numpy as np

#Load metadata and retrieve relevant columns.
metadata = pd.read_csv(metadata)
metadata = metadata[['SampleID','Treatment','TreatmentDosageTreatTime',
                     'Dosage[uM]']]
    
#Load expression data.
all_rpm = pd.read_csv(all_rpm)

#Remove untreated wells. Retain treatments that occur in treatment condition.
metadata = metadata[(metadata.Treatment != 'none') &
                    (metadata.Treatment.isin(all_rpm.Treatment.unique()))]

#Remove wells without multiple dosages.
num_dosages = metadata.groupby('Treatment')['Dosage[uM]'].nunique()
metadata = metadata[metadata.Treatment.isin(num_dosages[num_dosages > 1].index)]
    
#Log normalize dosage.
metadata['Dosage[uM]'] = np.log10(metadata['Dosage[uM]'])
    
#Output reformatted metadata to CSV.
metadata.to_csv("../results/metadata.reformatted.csv",index=False)