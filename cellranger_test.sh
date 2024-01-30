#!/bin/bash

# to be run in the gabi project directory
#/home/mark.ziemann@domain.internal.burnet.edu.au/projects/gabi

cellranger-arc count --id=FLW_april \
                       --reference=ref_combined1/ref_combined1 \
                       --libraries=libraries_april.csv \
                       --localcores=32 \
                       --localmem=64

#cellranger-arc count --id=FLW_august \
#                       --reference=ref_combined1/ref_combined1 \
#                       --libraries=libraries_august.csv \
#                       --localcores=32 \
#                       --localmem=64
