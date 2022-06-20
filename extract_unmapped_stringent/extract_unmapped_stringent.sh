#########################################################################################################

# The MIT License (MIT) Copyright (c) 2020 Alexander J. Probst

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial 
# portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION #WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#########################################################################################################

#!/bin/bash

if [ "$#" -lt 3 ]
then
  echo "usage: extract_unmapped.sh <sam-file> <fwd-fastq> <rev-fastq>"
  echo "where <sam-file> is a SAM file output from e.g. bowtie2 mapping."
  echo "<fwd-fastq> is the path to the foward fastq file and <rev-fastq> is the path to the reverse fastq file."
  echo "The script outputs two files with unmapped reads (unmapped.1.fastq, unmapped.2.fastq), of which either the forward, the reverse, or both did not map to the query."
  echo "output folder is current folder"
  exit 1
fi

# input sam file
sam=$1
reads1=$2
reads2=$3

# extracting unmapped reads
echo "filtering sam..."
awk '{ if ($3 != "*") print $1 }' $sam | sort -u > readIDs.tmp
echo "creating fastq files..."
pullseq -i $reads1 -e -n readIDs.tmp > unmapped_stringent.1.fastq
pullseq -i $reads2 -e -n readIDs.tmp > unmapped_stringent.2.fastq
rm readIDs.tmp
echo "... done!"
