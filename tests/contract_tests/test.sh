#! /bin/sh

if test $# -eq 2; then
  testfiles="$2"	## test file is given as unique extra argument
else
  testfiles="ar*.erl f*.erl d*.erl case*.erl cont*.erl i*.erl li*.erl s*.erl p*.erl tu*.erl"
fi

HIPE=$1/bin/erl
ERLC=$1/bin/erlc
DIALYZER=$1/lib/dialyzer
DIALYZER_EBIN=$DIALYZER/ebin

if test ! -x "${HIPE}" ; then
    echo "Usage: test OTP_DIR [testfile[.erl]]"
    exit 0
fi

check_succtype ()
{
    $1 -noshell -pa $2 -run only_succ_typings doit $3 -s init stop
}

check_contract ()
{
    $1 -noshell -pa $2 -run dialyzer_succ_typings doit $3 -s init stop
}

printf "Recompiling only_succ_typings..."
${ERLC} only_succ_typings.erl
printf " done\n"
printf "Proceeding with tests\n"

for file in $testfiles ; do
    test=`basename $file .erl`
    printf "\nTesting "$test".erl: "
    full_hostname=`hostname`
    resfile1="${test}_new@${full_hostname}"
    if test -f ${resfile1}; then rm -f ${resfile1}; fi

    touch ${resfile1}

    printf "\n--------   Success typings   ---------\n" > ${resfile1}
    check_succtype $HIPE $DIALYZER_EBIN $test >> ${resfile1}
    printf "\n\n-----------   Contracts   ------------\n" >> ${resfile1}
    check_contract $HIPE $DIALYZER_EBIN $test >> ${resfile1}

    
    if diff -sN ${resfile1} ${test}_old > /dev/null 2>&1; then
        # zero return status means no diff
	printf "OK\n"
	rm -f ${resfile1}
    else
        # this time we send the output to the log
	printf "\n*** $resfile1 and ${test}_old differ!!!\n"
	diff -sN ${resfile1} ${test}_old
    fi
    
done

echo
#============================================================================
