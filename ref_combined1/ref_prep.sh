
#!/bin/bash

cat ../pathogens/pathogen.fa ../ref2/refdata-cellranger-arc-GRCh38-2020-A-2.0.0/fasta/genome.fa > genome.fa
cat ../pathogens/pathogen.gtf ../ref2/refdata-cellranger-arc-GRCh38-2020-A-2.0.0/genes/genes.gtf > genes.gtf

echo '{
    organism: "HumanGRCh38 and pathogens"
    genome: ["ref_combined1"]
    input_fasta: ["genome.fa"]
    input_gtf: ["genes.gtf"]
}' > ref_combined1.config

rm -rf ref_combined1

cellranger-arc mkref --config=ref_combined1.config
