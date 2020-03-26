########## PRE-PIPELINE RAW DATA PREPARATION ##########
#191211_MinION

##### Guppy #####
https://community.nanoporetech.com/downloads
#See https://github.com/MaestSi/ONTrack/ for a suggestion to download Guppy if you don't have access to the ONT Community

#Pre-pipeline Guppy basecalling
/ont-guppy-cpu-2/bin/guppy_basecaller -i /path/to/rawdata/191211_MinION/fast5/files -s /path/to/rawdata/191211_MinION/Guppy_output --flowcell FLO-MIN107 --kit SQK-LSK109 -r cpu_threads_per_caller 8

#Pre-pipeline Guppy demultiplexing
/ont-guppy-cpu-2/bin/guppy_barcoder -i /path/to/rawdata/191211_MinION/Guppy_output -s /path/to/rawdata/191211_MinION/Guppy_output/barcoder_output/ -t 8



##### Consensus preparations #####
#Pre-pipeline merging and renaming of files (ONTrack requires filenames to be 'BC*.fastq')
#Merge all Guppy output fastq's into one fastq file
cd /path/to/rawdata/191211_MinION/Guppy_output/barcoder_output/
cd barcode05/
cat *.fastq > /path/to/rawdata/191211_MinION/Guppy_output/barcoder_output/BC05.fastq
cd ../barcode06/
cat *.fastq > /path/to/rawdata/191211_MinION/Guppy_output/barcoder_output/BC06.fastq
cd ../barcode07/
cat *.fastq > /path/to/rawdata/191211_MinION/Guppy_output/barcoder_output/BC07.fastq

#Moving reads to new ONTrack folder for analyses
cd /path/to/rawdata/191211_MinION/
mkdir ONTrack #make a new directory to work from
mv /path/to/rawdata/191211_MinION/Guppy_output/barcoder_output/*.fastq /path/to/rawdata/ONTrack
#This is at what stage you'll be When you've downloaded the raw data files from the European Nucleotide Archive project number ###.



########## POST-DEMULTIPLEXING DATA ANALYSIS ##########
#Assumed data stucture:
#Downloaded .fastq files from ENA, saved in
/path/to/rawdata/191211_MinION/ONTrack #3 fastq files
#Downloaded .fast5 files from SURFdrive, saved in
/path/to/rawdata/191211_MinION/fast5 #30 fast5 files
#Downloaded sequencing summary file from SURFdrive, saved in
/path/to/rawdata/191211_MinION #1 txt file
#Make sure to have unzipped the downloaded data:
gunzip *.gz

pwd #check where you're working
cd /path/to/rawdata/191211_MinION/ONTrack #switch to folder which holds the fastq files



##### Nanoplot #####
#Install Nanoplot according to instructions:
https://github.com/wdecoster/NanoPlot
#Explore data with Nanoplot
mkdir ../NanoPlot #make a new directory to hold the output
NanoPlot --fastq BOC05.fastq --loglength -o ../Nanoplot/BC05
NanoPlot --fastq BOC06.fastq --loglength -o ../Nanoplot/BC06
NanoPlot --fastq BOC07.fastq --loglength -o ../Nanoplot/BC07



##### Porechop #####
#Install Porechop according to instructions:
https://github.com/rrwick/Porechop

#Manually add the following primer information to adapter.py file, following the instructions on Porechop GitHub:
# Nematode primers Ineke Knot
Adapter('SSU18A',
        start_sequence=('SSU18A_F',       'AAAGATTAAGCCATGCATG'),
        end_sequence=  ('SSU18A_F_revcom','CATGCATGGCTTAATCTTT')),
Adapter('SSU26R',
        start_sequence=('SSU26R_R',       'CATTCTTGGCAAATGCTTTCG'),
        end_sequence=  ('SSU26R_R_revcom','CGAAAGCATTTGCCAAGAATG')),

Adapter('SSU18A_MinION',
        start_sequence=('SSU18A_MinION_F',       'TTTCTGTTGGTGCTGATATTGCAAAGATTAAGCCATGCATG'),
        end_sequence=  ('SSU18A_MinION_F_revcom','CATGCATGGCTTAATCTTTGCAATATCAGCACCAACAGAAA')),
Adapter('SSU26R_MinION',
        start_sequence=('SSU26R_MinION_R',       'ACTTGCCTGTCGCTCTATCTTCCATTCTTGGCAAATGCTTTCG'),
        end_sequence=  ('SSU26R_MinION_R_revcom','CGAAAGCATTTGCCAAGAATGGAAGATAGAGCGACAGGCAAGT')),


Adapter('Nem_18S_F',
        start_sequence=('Nem_18S_F',       'CGCGAATNGCTCATTACAACAGC'),
        end_sequence=  ('Nem_18S_F_revcom','GCTGTTGTAATGAGCNATTCGCG')),
Adapter('Nem_18S_R',
        start_sequence=('Nem_18S_R',       'GGGCGGTATCTGATCGCC'),
        end_sequence=  ('Nem_18S_R_revcom','GGCGATCAGATACCGCCC')),

Adapter('Nem_18S_MinION_F',
        start_sequence=('Nem_18S_F',       'TTTCTGTTGGTGCTGATATTGCCGCGAATNGCTCATTACAACAGC'),
        end_sequence=  ('Nem_18S_F_revcom','GCTGTTGTAATGAGCNATTCGCGGCAATATCAGCACCAACAGAAA')),
Adapter('Nem_18S_MinION_R',
        start_sequence=('Nem_18S_R',       'ACTTGCCTGTCGCTCTATCTTCGGGCGGTATCTGATCGCC'),
        end_sequence=  ('Nem_18S_R_revcom','GGCGATCAGATACCGCCCGAAGATAGAGCGACAGGCAAGT')),

#Removing adapters and another round of demultiplexing
porechop -i ONTrack -b ONTrack/porechop_demultiplexing --require_two_barcodes



##### ONTrack #####
https://github.com/MaestSi/ONTrack
#Moving trimmed BC files from Porechop to 'trimmed' folder for ONTrack use
mv /path/to/rawdata/191211_MinION/ONTrack/porechop_demultiplexing/BC*.fastq /path/to/rawdata/191211_MinION/ONTrack/trimmed
cd #to go back to your normal home working directory
cd path/to/ONTrack/pipeline #Note: this is the directory where you installed the ONTrack pipeline. This is different from the path/to/rawdata/191211_MinION/ONTrack folder mentioned above
source activate ONTrack_env

#Make .fasta files from .fastq files
seqtk seq -A /path/to/rawdata/ONTrack/trimmed/BC05.fastq > /path/to/rawdata/ONTrack/trimmed/BC05.fasta #Anisakis simplex
seqtk seq -A /path/to/rawdata/ONTrack/trimmed/BC06.fastq > /path/to/rawdata/ONTrack/trimmed/BC06.fasta #Panagrellus redivivus
seqtk seq -A /path/to/rawdata/ONTrack/trimmed/BC07.fastq > /path/to/rawdata/ONTrack/trimmed/BC07.fasta #Turbatrix aceti

#Double-check whether directories for PIPELINE_DIR, MINICONDA_DIR and BASECALLER_DIR are modified/correct in config_MinION_mobile_lab.R, as per ONTrack installation description

#ONTrack info
#home directory
/path/to/rawdata/191211_MinION/ONTrack/trimmed
#fast5 directory
/path/to/rawdata/191211_MinION/fast5
#Summary file
/path/to/rawdata/191211_MinION/sequencing_summary.txt

#ONTrack run
Rscript ONTrack.R /path/to/rawdata/191211_MinION/ONTrack/trimmed /path/to/rawdata/191211_MinION/fast5 /path/to/rawdata/191211_MinION/sequencing_summary.txt


