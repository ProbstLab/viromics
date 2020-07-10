# Endmatcher.sh script

Script for the identification of circular elements from .sam mapping files

Conceptualization by Alexander J. Probst and Scripting by Till L.V. Bornemann
Contact: till.bornemann@uni-due.de

The script is distributed under the MIT licence (see accompanying LICENSE file)

# Requirements
The Endmatcher script is run using the bourne-shell and utilizes GNU-awk (gawk) and awk commands. These commands should be natively available on most Linux distributions. Alternatively, they can be installed e.g. using the apt-get interface. Windows users may need to install a virtual machine running a Linux distribution like Ubuntu using e.g. virtualBox (https://www.virtualabox.org). We recommend using Bowtie2 (http://bowtie-bio.sourceforge.net/bowtie2/index.shtml , available e.g. via conda) for the mapping and will refer to Bowtie2 flags in the following but in principle any mapper should work, as long as it produces a valid .sam file output (with the .sam header) and has a flag to allow alternate alignments.   
Usage. The Endmatcher.sh script has two positional arguments, 

1) a fasta file containing the contig or scaffold sequences that reads were mapped on and 
2) the mapping of said reads on the fasta file in the .sam format. 

The .sam file needs to have been generated using the -a flag (if using Bowtie2) to allow for alternate alignments.

# Basic command 
```bash
bash Endmatcher.sh {scaffolds.fasta} {sam-file}
```
Depending on the read format (if the for/rev read info is ), the information that a read is the for- or rev-read is truncated in the .sam-output, thus making the read-IDs of both mates identical in the sam file. 

Example:
@NB500928:133:HM7THBGX5:1:11101:14573:1073 1:N:0:AAGGAC 

Will be truncated to 
@NB500928:133:HM7THBGX5:1:11101:14573:1073

This in combination with the -a flag allowing for multiple alignments makes it impossible to tell from the .sam-file alone if for/rev -readIDs are unique and this information is required for the quality control step of only taking candidate read pairs that only align on the target scaffold. If the for/rev-readIDs are unique, then both IDs should appear only once. If for/rev-readIDs are identical because of the truncation, then their ID should appear twice in the .sam file. The current script assumes the for/rev-readIDs to be identical and manual adjustment is necessary if this is not the case. 

# Helper script usage

The supplied auxillatory script ID_if_forrevreadidsareidenticalinsam.sh with the usage
```bash
bash ID_if_forrevreadidsareidenticalinsam.sh {for-read-fastq} {rev-read-fastq}
```
compares the first for and rev read and prints out 1 (unique for/rev readIDs after trunc) or 2 (identical for-/rev-readIDs after trunc) and could be used as a basis to automatize the setting of this parameter. Both unzipped and fastq.gz files are valid read files for this script.

# Concept behind the Endmatcher.sh script

If a scaffold is in reality a circular element, e.g. a virus or a plasmid, then some read pairs should also cover the area connecting both ends of the respective scaffold. The script basically identifies read pairs where each mate aligns on the start or end of the scaffold respectively (first or last 500 bp of the scaffold). 500 bp was chosen as short read sequencing generally targets ~500 bp as the insert size (defined herein as the length of the start of for-read – end of rev-read) and thus valid candidates should end before the 500 bp mark on the respective end. As added quality control, alternate mappings are reported during mapping and candidate read pairs need to not have alternate mappings (they both must only align on the candidate circular scaffold). We chose five read pairs linking both ends as the cutoff for the identification of candidates for circular scaffolds.
Post-processing. Candidate circular Scaffolds < 3 kbp length were discarded as they both have too little information if they are valid candidates and as we needed a stringent enough threshold to make sure that alignment of read pairs across the “visible” length of the scaffold in the first and last 500 bp is not realistic (for a 3 kbp scaffold, the required insert size for this would be more then 2 kbp and is thus far from a realistic for normal short reads).


