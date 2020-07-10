#!/bin/bash



## Usage
#input files are the scaffold file that was used for the mapping and the mapping (sam) file
scaffolds=$1
samfile=$2

# this command
#1) goes through the sam header containing the scaffold length and the ID's and saves the scaffold lengths in an array with the scaffoldIDs as keys
# 2) goes through the sam body and if the forword read is in the first 499 bp and the reverse read is in the last 500 bp the line of the sam file is saved in output.sam
gawk -F"SN:|LN:|\t|" 'NR==FNR && $1 ~ /^@SQ/ {set[$3]["len"]=$NF}  NR !=FNR && $1 !~ "^@" && $4 < 500 && $9 > set[$3]["len"] - 500 {print $0}' $samfile $samfile > output.sam

## this commmand
# 1) gets the number of reads that passed the previous filtering per scaffold, checks if there are more than 9 reads per scaffold and then saves the scaffold names in read_count_p_scaff.txt
cut  -f 3 output.sam | sort | uniq -c | awk '$1>9{print$0} ' > read_count_p_scaff.txt
# this command
# 1) saves a list of the scaffold names in read_count_p_scaff.txt which are the candidates for possible circular sequences
# 2) prints out the read and scaffold names of the output.sam file where the scaffold names belong to the defined candidates into read_ID.txt
awk 'NR==FNR {scaffoldnames[$2]=""} 
     NR!=FNR&&$1!~/^@/ {if ($3 in scaffoldnames) {print$1"\t"$3}}' read_count_p_scaff.txt output.sam  > read_ID.txt
# this command
# 1) saves the read names in an array with the read names as key and 0 as value
# 2) checks in for each line in the original sam file body, if the readid inn the line is in the array defined in 1) and if so, adds 1 to it 
# - reasoninng: If alternate alignments are allowed during mapping, the same readID might map to multiple lines and that is an exclusion criterion for the respective read pair, giving additional confidennce to the analyses
## IMPORTANT
# - depending on the format of the reads, their for/rev read specification can be trimmed away, thus giving for/rev reads the same ID
# - this means that the scaffoldnames[i]==1 needs to be changed to ==2 instead
## 3) prints out all reads that did align only once (depending on the issue above, for/rev reads are summed together to align twice as a sum) 
awk -F"\t" 'NR==FNR {scaffoldnames[$1]=0}
     NR!=FNR && $1!~/^@/ {if ($1 in scaffoldnames) {scaffoldnames[$1]+=1}  }
END{for(i in scaffoldnames){
if(scaffoldnames[i] == 2) {print i}
                           }
   }' read_ID.txt $samfile > output_reads.txt

## this command
# 1) extracts sam file lines with the filtered rread IDs, checks which scaffolds have more than 9 hits and then extracts the sequences of those 
grep -f output_reads.txt read_ID.txt | cut -f 2 | sort | uniq -c | awk '$1>9{print$NF}'| pullseq -N -i $scaffolds > ${scaffolds}_circ_final_RM.fasta  
