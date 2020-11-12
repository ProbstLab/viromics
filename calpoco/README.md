### Calpoco - Calculation of nucleotide-position wise coverage of a scaffold from .sam mapping files

## requirements
- requires ruby with the nu and trollop gems
- the .sam file should contain ONLY mapped reads. Unmapped reads can be removed using e.g. shrinksam or the mapped.py script. 
- the mapping should only have been done on a SINGLE scaffold

## usage

```
ruby calc_cov_pos.rb  -sam {samfile} > {output}
```

## output
- the output is a two-column table, the first column designating the nucleotide position on the mapped scaffold and the second column giving the respective coverage.
