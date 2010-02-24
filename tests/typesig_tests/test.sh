#! /bin/sh

if test $# -eq 2; then
  testfiles="$2"	## test file is given as unique extra argument
else
  testfiles="a*.erl b*.erl \
	     case*.erl catch1.erl cons.erl \
	     exit.erl equal1.erl fib*.erl fun*.erl \
	     guard1.erl guard2.erl guard4.erl guard5.erl\
	     inf_loop*.erl int_mult1.erl is_funct?.erl is_record*.erl \
	     karol.erl \
	     letrec1.erl list*.erl \
	     mfalist.erl\
	     orelse1.erl\
	     product1.erl\
	     range*.erl\
	     rec*.erl refined_bug1.erl sequence.erl try*.erl spawn4.erl \
	     t_union1.erl\
	     tak.erl trecord*.erl tuple*.erl type_widening1.erl"
  ## The following files are currently not giving right results
  #testfiles="guard3.erl record2.erl"
fi

HIPE=$1/bin/erl
ERLC=$1/bin/erlc
DIALYZER=$1/lib/dialyzer
DIALYZER_EBIN=$DIALYZER/ebin

if test ! -x "${HIPE}" ; then
    echo "Usage: test OTP_DIR [testfile[.erl]]"
    exit 0
fi

check_typesig ()
{
    $1 -noshell -pa $2 -run dialyzer_succ_typings doit $3 -s init stop
}

compare_analyses ()
{
    $1 -noshell -pa $2 -run compare_analyses doit $3 -s init stop
}

printf "Recompiling compare_analyses..."
${ERLC} compare_analyses.erl
printf " done\n"
printf "Proceeding with tests\n"

for file in $testfiles ; do
    test=`basename $file .erl`
    printf "\nTesting "$test".erl: "
    full_hostname=`hostname`
    resfile1="${test}_new@${full_hostname}"
    resfile2="${test}_compare_new@${full_hostname}"
    if test -f ${resfile1}; then rm -f ${resfile1}; fi
    if test -f ${resfile2}; then rm -f ${resfile2}; fi

    touch result.tmp ${resfile1}

    check_typesig $HIPE $DIALYZER_EBIN $test > result.tmp

    sort -o ${resfile1} result.tmp
    rm -f result.tmp
    
    if diff -sN ${resfile1} ${test}_old > /dev/null 2>&1; then
        # zero return status means no diff
	printf "OK\n"
	rm -f ${resfile1}
    else
        # this time we send the output to the log
	printf "\n*** $resfile1 and ${test}_old differ!!!\n"
	diff -sN ${resfile1} ${test}_old
    fi
    
    printf "Comparing analyses "$test".erl: "
    compare_analyses $HIPE $DIALYZER_EBIN $test > ${resfile2}
    
    if diff -sN ${resfile2} ${test}_compare_old > /dev/null 2>&1; then
        # zero return status means no diff
	printf "OK\n"
	rm -f ${resfile2}
    else
        # this time we send the output to the log
	printf "\n*** $resfile2 and ${test}_compare_old differ!!!\n"
	diff -sN ${resfile2} ${test}_compare_old
    fi
done

echo
#============================================================================
