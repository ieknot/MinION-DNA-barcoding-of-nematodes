########## PRE-PIPELINE RAW DATA PREPARATION ##########
#190715_MinION

##### Guppy #####
https://community.nanoporetech.com/downloads
#See https://github.com/MaestSi/ONTrack/ for a suggestion to download Guppy if you don't have access to the ONT Community

#Pre-pipeline Guppy basecalling
/ont-guppy-cpu-2/bin/guppy_basecaller -i /path/to/rawdata/190715_MinION/fast5/files/ -s /path/to/rawdata/190715_MinION/Guppy_output --flowcell FLO-MIN107 --kit SQK-LSK109 -r cpu_threads_per_caller 8

#Pre-pipeline Guppy demultiplexing
/ont-guppy-cpu-2/bin/guppy_barcoder -i /path/to/rawdata/190715_MinION/Guppy_output -s /path/to/rawdata/190715_MinION/Guppy_output/barcoder_output/ -t 8



##### Consensus preparations #####
#Rename file (ONTrack requires filenames to be 'BC*.fastq')
cd /path/to/rawdata/190715_MinION/Guppy_output/barcoder_output/barcode10/
mv fastq_runid_<name>.fastq ../BC10.fastq #replace <name> by full fastq file name

#Moving reads to new ONTrack folder for analyses
cd /path/to/rawdata/190715_MinION/
mkdir ONTrack #make a new directory to work from
mv /path/to/rawdata/190715_MinION/Guppy_output/barcoder_output/*.fastq /path/to/rawdata/190715_MinION/ONTrack
#This is at what stage you'll be When you've downloaded the raw data files from the European Nucleotide Archive project number ###.



########## POST-DEMULTIPLEXING DATA ANALYSIS ##########
#Assumed data stucture:
#Downloaded .fastq files from ENA, saved in
/path/to/rawdata/190715_MinION/ONTrack #1 fastq file
#Downloaded .fast5 files from SURFdrive, saved in
/path/to/rawdata/190715_MinION/fast5 #1 fast5 file
#Downloaded sequencing summary file from SURFdrive, saved in
/path/to/rawdata/190715_MinION #1 txt file

pwd #check where you're working
cd /path/to/rawdata/190715_MinION/ONTrack #switch to folder which holds the fastq files



##### Nanoplot #####
#Install Nanoplot according to instructions:
https://github.com/wdecoster/NanoPlot
#Explore data with Nanoplot
mkdir NanoPlot
NanoPlot --fastq BOC10.fastq --loglength -o ../Nanoplot/BC10



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
mv /path/to/rawdata/ONTrack/porechop_demultiplexing/BC*.fastq /path/to/rawdata/ONTrack/trimmed
cd #to go back to your normal home working directory
cd path/to/ONTrack/pipeline #Note: this is the directory where you installed the ONTrack pipeline. This is different from the path/to/rawdata/190715_MinION/ONTrack folder mentioned above
source activate ONTrack_env

#Make .fasta files from .fastq files
seqtk seq -A /path/to/rawdata/190715_MinION/ONTrack/trimmed/BC10.fastq > /path/to/rawdata/190715_MinION/ONTrack/trimmed/BC10.fasta #Caenorhabditis elegans

#Double-check whether directories for PIPELINE_DIR, MINICONDA_DIR and BASECALLER_DIR are modified/correct in config_MinION_mobile_lab.R, as per ONTrack installation description

#ONTrack info
#home directory
/path/to/rawdata/190715_MinION/ONTrack/trimmed
#fast5 directory
/path/to/rawdata/190715_MinION/fast5
#Summary file
/path/to/rawdata/190715_MinION/sequencing_summary.txt

#ONTrack run
Rscript ONTrack.R /path/to/rawdata/190715_MinION/ONTrack/trimmed /path/to/rawdata/190715_MinION/fast5 /path/to/rawdata/190715_MinION/sequencing_summary.txt


