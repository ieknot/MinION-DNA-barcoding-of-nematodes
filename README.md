# DNA barcoding of nematodes using the MinION

This page holds the code for replicating the data analyses in Knot I.E., Zouganelis G.D., Weedall G.D., Wich S.A. & Rae R. (2020) DNA Barcoding of Nematodes Using the MinION. Front. Ecol. Evol. 8:100. [doi: 10.3389/fevo.2020.00100](https://www.frontiersin.org/articles/10.3389/fevo.2020.00100/full). It also contains the links to the needed data, which can be downloaded from the European Nucleotide Archive (ENA) and SURFdrive.

## Data
The data of this study were generated in two separate MinION runs. Therefore, the bioinformatics and data is labelled and separated per run date.
* \<191211_MinION\>: Data of three individual nematode DNA samples, indexed with MinION barcodes and multiplexed on 1 new flow cell. Accession numbers represent _Anisakis simplex_, _Panagrellus redivivus_ and _Turbatrix aceti_, respectively.
* \<190715_MinION\>: Data of one individual nematode DNA sample, indexed with a MinION barcode because the sample was run on a reused flow cell. Accession numbers represent _Caenorhabditis elegans_.

**MinION**

The **fastq** files of this study can be found at the ENA, project number [PRJEB37489](https://www.ebi.ac.uk/ena/browser/view/PRJEB37489). 
* 191211_MinION: samples [ERS4397495](https://www.ebi.ac.uk/ena/browser/view/ERS4397495)/[ERX4031716](https://www.ebi.ac.uk/ena/browser/view/ERX4031716), [ERS4397496](https://www.ebi.ac.uk/ena/browser/view/ERS4397496)/[ERX4031715](https://www.ebi.ac.uk/ena/browser/view/ERX4031715) and [ERS4397497](https://www.ebi.ac.uk/ena/browser/view/ERS4397497)/[ERX4031717](https://www.ebi.ac.uk/ena/browser/view/ERX4031717)
* 190715_MinION: sample [ERS4397498](https://www.ebi.ac.uk/ena/browser/view/ERS4397498)/[ERX4031718](https://www.ebi.ac.uk/ena/browser/view/ERX4031718)

The **raw fast5 and sequencing summary** files are necessary for the [ONTrack](https://github.com/MaestSi/ONTrack) pipeline. They can be found on and downloaded from this SURFdrive:
* 191211_MinION: https://surfdrive.surf.nl/files/index.php/s/VllkkyErCjUo900
* 190715_MinION: https://surfdrive.surf.nl/files/index.php/s/LiAKPcUPpAldbNM

**Sanger**

Sanger **fasta** consensus sequences are available at GenBank:
* 191211_MinION: accession numbers [MT246663](https://www.ncbi.nlm.nih.gov/nuccore/MT246663), [MT246664](https://www.ncbi.nlm.nih.gov/nuccore/MT246664) and [MT246665](https://www.ncbi.nlm.nih.gov/nuccore/MT246665)
* 190715_MinION: accession number [MT246666](https://www.ncbi.nlm.nih.gov/nuccore/MT246666)

## Code
The code needed to replicate the bioinformatics is separated by ‘Pre-pipeline raw data preparation’ part, up to the fastq files found in the European Nucleotide Archive (see above), and the ‘Post-demultiplexing data analysis’ part, from which you can run the analyses without having to redo the basecalling and demultiplexing. For more information and details about the bioinformatics analyses, including version numbers of the tools used, see our [manuscript](https://www.frontiersin.org/articles/10.3389/fevo.2020.00100/full). Software packages used are [Guppy](https://community.nanoporetech.com/downloads) (ONT Community acces required), [Nanoplot](https://github.com/wdecoster/NanoPlot), [Porechop](https://github.com/rrwick/Porechop) and the bioinformatics pipeline [ONTrack](https://github.com/MaestSi/ONTrack).
* bioinformatics_191211_MinION.sh: contains all the code needed to replicate the bioinformatics performed for the 191211_MinION run
* bioinformatics_190715_MinION.sh: contains all the code needed to replicate the bioinformatics performed for the 190715_MinION run


## Citation
If this analysis or information is useful for your work, please consider citing our [manuscript](https://www.frontiersin.org/articles/10.3389/fevo.2020.00100/full).

Knot I.E., Zouganelis G.D., Weedall G.D., Wich S.A. & Rae R. (2020) DNA Barcoding of Nematodes Using the MinION. Front. Ecol. Evol. 8:100. [doi: 10.3389/fevo.2020.00100](https://www.frontiersin.org/articles/10.3389/fevo.2020.00100/full).
