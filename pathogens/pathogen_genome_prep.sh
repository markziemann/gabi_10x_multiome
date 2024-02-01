#!/bin/bash

rm pathogen.fa pathogen.gtf

for FNA in $(find ncbi_dataset/data | grep fna | grep -v cds | grep -v rev) ; do

  REV=$(echo $FNA | sed 's/.fna/rev.fna/')

  revseq $FNA $REV

  sed -i '/>/s/ /fwd /' $FNA
  sed -i '/>/s/ /rev /' $REV


  cat $FNA $REV > pathogen.fa

  END=$(sed 1d $FNA | wc -c )

  CONTIGNAME=$(head -1 $FNA | cut -d ' ' -f1 | tr -d '>')

  echo "$CONTIGNAME custom transcript 1 $END . + . gene_id@\"${CONTIGNAME}.fwd\";@transcript_id@\"${CONTIGNAME}.fwd\";" | tr ' ' '\t' | tr '@' ' ' >> pathogen.gtf
  echo "$CONTIGNAME custom exon 1 $END . + . gene_id@\"${CONTIGNAME}.fwd\";@transcript_id@\"${CONTIGNAME}.fwd\";" | tr ' ' '\t' | tr '@' ' ' >> pathogen.gtf
  echo "$CONTIGNAME custom gene 1 $END . + . gene_id@\"${CONTIGNAME}.fwd\";" | tr ' ' '\t' | tr '@' ' ' >> pathogen.gtf

  CONTIGNAME=$(head -1 $REV | cut -d ' ' -f1 | tr -d '>')

  echo "$CONTIGNAME custom transcript 1 $END . - . gene_id@\"${CONTIGNAME}.rev\";@transcript_id@\"${CONTIGNAME}.rev\";" | tr ' ' '\t' | tr '@' ' ' >> pathogen.gtf
  echo "$CONTIGNAME custom exon 1 $END . - . gene_id@\"${CONTIGNAME}.rev\";@transcript_id@\"${CONTIGNAME}.rev\";" | tr ' ' '\t' | tr '@' ' ' >> pathogen.gtf
  echo "$CONTIGNAME custom gene 1 $END . - . gene_id@\"${CONTIGNAME}.rev\";" | tr ' ' '\t' | tr '@' ' ' >> pathogen.gtf

done

