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
    samtools index $BAMOUT

  done

done


# Make bedgraph format of ATAC signal for the different major cell types for FLW samples
# TET2 HG38
REGION=chr4:105013948-105412731
G=ref_combined1/ref_combined1/fasta/genome.fa.g

for CELLTYPE in $(find . | grep atac_possorted | grep -v bam.bam | grep bam$ | rev | cut -d '/' -f1 | rev | sed 's/atac_possorted_//' | sort -u) ; do

  echo $CELLTYPE

  BEDGRAPH=$CELLTYPE.bdg.gz

  for BAM in $(find | grep FLW | grep $CELLTYPE$) ; do

    samtools view -H $BAM > header.sam

    BAI=$BAM.bai

    if [ ! -r $BAI ] ; then samtools index $BAM ; fi

    samtools view $BAM $REGION

  done > tmp.sam

  cat header.sam tmp.sam \
  | samtools view -bS \
  | samtools sort \
  | bamToBed   \
  | bedtools genomecov -i - -bg -g $G \
  | pigz > $BEDGRAPH

done

