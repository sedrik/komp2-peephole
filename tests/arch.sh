#! /bin/sh

##====================================================================
## File:      arch.sh
## Author(s): Jesper W
## Purpose:   To test the HiPE system with all memory architectures.
##
## $Id: arch.sh,v 1.2 2003/12/18 12:34:30 jesperw Exp $
##====================================================================

OSH_DIR=$1

echo --------------------------------------------------------------------
echo "| Testing Private heap"
echo "|"
./testsuite.sh $OSH_DIR
echo --------------------------------------------------------------------
echo "| Testing Shared heap"
echo "|"
./testsuite.sh --rts_opts -shared $OSH_DIR
echo --------------------------------------------------------------------
echo "| Testing Hybrid heap"
echo "|"
./testsuite.sh --rts_opts -hybrid $OSH_DIR
