#! /bin/sh

##====================================================================
## File:      ra.sh
## Author(s): Kostis Sagonas
## Purpose:   To test the HiPE system with all register allocators.
##
## $Id: ra.sh,v 1.4 2004/12/09 16:42:18 kostis Exp $
##====================================================================

# Run from testsuite directory
startdir=`pwd`
testdir=`dirname $0`
cd $testdir

if test $# -eq 0; then
    OTP_DIR=$startdir
else
    OTP_DIR=$1
fi

./testsuite.sh --comp_opts "[o2,\{regalloc,naive\}]" $OTP_DIR
./testsuite.sh --comp_opts "[o2]" "$OTP_DIR"	## this tests the default RA
./testsuite.sh --comp_opts "[o2,\{regalloc,linear_scan\}]" "$OTP_DIR"
./testsuite.sh --comp_opts "[o2,\{regalloc,graph_color\}]" "$OTP_DIR"
./testsuite.sh --comp_opts "[o2,\{regalloc,coalescing\}]" "$OTP_DIR"
