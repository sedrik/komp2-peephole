#! /bin/sh

#============================================================================
echo "------------------------------------------------------------------------"
echo "---                  Running loader_tests/test.sh                    ---"
echo "------------------------------------------------------------------------"

HIPE=$1
COMP_FLAGS=$2
ERL_FLAGS=$3

testfiles="load_bug?.erl load_sticky_compressed.erl"

testdir="loader_tests"

#============================================================================

. ../test_common.sh

#============================================================================