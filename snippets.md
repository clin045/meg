Setup
```
rosetta
matlab (separate window)
```

Run scripts
```
snakemake -pc1 data/labels/558CTL0505M_R-vannest-SRT_20190730_01.txt
snakemake -pc1 data/preprocessing/558CTL0505M_R-vannest-SRT_20190730_01/ica.mat
snakemake -pc1 data/source_recon/558CTL0505M_R-vannest-SRT_20190730_01/sourceInt.mat
```