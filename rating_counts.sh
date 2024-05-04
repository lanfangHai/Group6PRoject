#!/bin/bash
input_file="$1"
tar -xzf R413.tar.gz

export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages
Rscript plot.R $input_file

