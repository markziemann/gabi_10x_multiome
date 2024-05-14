#!/bin/bash

# the purpose here is to partition the ATAC data by cell type, inferred from the scRNA-seq data
# the resulting BAM files will be used to generate genomic tracks for selected genes
#

tr '[:lower:]' '[:upper:]' < cellgroups.tsv > cellgroups_upper.tsv

for BAM in $(find . | grep atac | grep _bam.bam$ ) ; do

  SAMPLE=$(echo $BAM | cut -d '/' -f1)

  for CELL in "DENDRITIC CELLS" "B CELLS" "MONOCYTES" "NK CELLS" "T CELLS" ; do

    echo $BAM $CELL

    grep -i $SAMPLE cellgroups_upper.tsv | grep -w "$CELL" \
    | cut -f1 | cut -d ' ' -f2 \
    | cut -d '-' -f1 > $SAMPLE.bc.tmp

    CELLNAME=$(echo $CELL | sed 's/ /_/g' | tr '[:upper:]' '[:lower:]' )
    SAMOUT=$(echo $BAM | sed "s/_bam.bam/_${CELLNAME}.sam/" )
    BAMOUT=$(echo $BAM | sed "s/_bam.bam/_${CELLNAME}.bam/" )

    samtools view -H $BAM > $SAMOUT
    samtools view $BAM | grep -Ff $SAMPLE.bc.tmp >> $SAMOUT
    samtools view -bS $SAMOUT > $BAMOUT && rm $SAMOUT

  done

done

