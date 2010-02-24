#! /bin/sh

##====================================================================
## File:      stress.sh
## Author(s): Kostis Sagonas
## Purpose:   To stress-test the HiPE system.
##
## $Id: stress.sh,v 1.4 2005/02/07 15:17:17 kostis Exp $
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

## first test that there are no discrepancies in HiPE
time ./testsuite.sh --system "$OTP_DIR"
## test the inference of type signatures
./testsuite.sh --types "$OTP_DIR"
## run the testsuite with all register allocators
./ra.sh "$OTP_DIR"
## run the testsuite starting compilation from Core
./testsuite.sh --core "$OTP_DIR"
## finally, run the compiler_tests with the default allocator
time ./testsuite.sh --only compiler_tests "$OTP_DIR"
