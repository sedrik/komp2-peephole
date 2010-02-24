#! /bin/sh

#============================================================================
echo "------------------------------------------------------------------------"
echo "---                  Running compiler_tests/test.sh                  ---"
echo "------------------------------------------------------------------------"

HIPE=$1
COMP_FLAGS=$2
ERL_FLAGS=$3

HiPE_COMP_OPTS=$COMP_FLAGS
export HiPE_COMP_OPTS

testfiles="esmb.erl wings.erl hc.erl"

##===========================================================================
## NOTE: this does not use the same test.erl file as the other test dirs.
##===========================================================================

ix_exec ()
{
  {
    echo echo "ctest:start\("$2","$3","$4"\). halt\(\)." \| $1 $5 -pa . 
  } | sh
}

rm -f ctest.beam esmb_src/*.beam wings_src/*.beam
$HIPE -make   ## This makes ctest.beam
cd esmb_src
$HIPE -make   ## Create fresh .beam files for the esmb test
cd ..
cd wings_src
$HIPE -make   ## Create fresh .beam files for the wings test
cd ..

for file in $testfiles ; do
    test=`basename $file .erl`
    echo
    echo "Testing "$test".erl:"
    full_hostname=`hostname`
    resfile="${test}_new@${full_hostname}"
    if test -f ${resfile} ; then
	rm -f ${resfile}
    fi
    ix_exec $HIPE $test "$COMP_FLAGS" "\'$resfile\'" "$ERL_FLAGS"
    status=0
    diff -sN ${resfile} ${test}_old || status=1 2>&1
    if test "$status" = 0 ; then
	rm -f ${resfile}
    else
	echo "compiler_tests/$test differ!!!"
	diff -sN ${resfile} ${test}_old
    fi
done

echo
#============================================================================
