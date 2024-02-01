#!/bin/bash

rm pathogen.fa pathogen.gtf
rm `find . | grep rev.fna`

for FNA in $(find ncbi_dataset/data | grep fna | grep -v cds | grep -v rev) ; do

  REV=$(echo $FNA | sed 's/.fna/rev.fna/')

  revseq $FNA $REV

  sed '/>/s/ /fwd /' $FNA >> pathogen.fa
  sed '/>/s/ /rev /' $REV >> pathogen.fa

done

samtools faidx pathogen.fa

for CONTIG in $(cut -f1 pathogen.fa.fai ) ; do
  START=1
  END=$(samtools faidx pathogen.fa $CONTIG | sed 1d | tr -d '\n' | wc -c)
  CONTIGNAME=$(head -1 $FNA | cut -d ' ' -f1 | tr -d '>')
  echo "${CONTIG} custom transcript 1 $END . + . gene_id@\"${CONTIG}\";@transcript_id@\"${CONTIG}\";" | tr ' ' '\t' | tr '@' ' ' >> pathogen.gtf
  echo "${CONTIG} custom exon 1 $END . + . gene_id@\"${CONTIG}\";@transcript_id@\"${CONTIG}\";" | tr ' ' '\t' | tr '@' ' ' >> pathogen.gtf
  echo "${CONTIG} custom gene 1 $END . + . gene_id@\"${CONTIG}\";" | tr ' ' '\t' | tr '@' ' ' >> pathogen.gtf

done

