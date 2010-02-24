#! /bin/sh

## File:      testsuite.sh
## Author(s): Kostis Sagonas
## 
## $Id: testsuite.sh,v 1.61 2008/02/27 18:28:46 dalu7049 Exp $
##
## Run with option --help for usage information.

#===========================================================================
# This is supposed to automate the testsuite by checking the
# log for possible errors.
#===========================================================================
# The Erlang/OTP executable and compiler are assumed to be in:
#   $OTP/bin/erl
# and
#   $OTP/lib/hipe/ebin
# Also, the Dialyzer is assumed to be in:
#   $OTP/dialyzer
#===========================================================================

# Run from testsuite directory
startdir=`pwd`
testdir=`dirname $0`
cd $testdir

if test -n "$USER"; then
   USER=`whoami`
   export USER
fi

##
## Make default compiler options [o2]
##
comp_options=[o2]
ERL_COMPILER_OPTIONS=[nowarn_shadow_vars]

core_excl_tests="trivial_tests"	## no point
no_native_excl_tests="native_tests core_tests"
smp_excl_tests="memory_tests"
erl=erl

while test 1=1
do
    case "$1" in
     --rts_opt*)
	    shift
	    rts_options=$1
	    shift
	    ;;
     --comp_opt*)
	    shift
	    comp_options=$1
	    shift
	    ;;
     --add*)
	    shift
	    added_tests=$1
	    shift
	    ;;
     --excl*)
	    shift
	    excluded_tests=$1
	    shift
	    ;;
     --only*)
	    shift
	    only_tests=$1
	    shift
	    ;;
     --core)
	    shift
            comp_options="[core]"
	    excluded_tests="${core_excl_tests}"
            ;;
     --system)
	    shift
	    only_tests="system_tests"
	    comp_options="[no_native]"
            ;;
     --types)
	    shift
	    only_tests="typesig_tests"
	    comp_options="[]"
            ;;
     --no_nat*)
	    shift
	    comp_options="[no_native]"
	    excluded_tests="${no_native_excl_tests}"
	    ;;
     --nofrag)
	    shift
	    rts_options="-nofrag"
	    erl=cerl
            ;;
     --smp)
	    shift
	    rts_options="-smp"
	    excluded_tests="${smp_excl_tests}"
            ;;
     --hybrid)
	    shift
	    rts_options="-hybrid"
            ;;
     --hybrid-a)
	    shift
	    rts_options="-hybrid"
            ERL_COMPILER_OPTIONS="[{core_transform,cerl_hybrid_transform},nowarn_shadow_vars]"
            ;;
     --bitlevel)
            shift
            ERL_COMPILER_OPTIONS="[bitlevel_binaries,nowarn_shadow_vars]"
	    ;;
     --bincomp)
            shift
            ERL_COMPILER_OPTIONS="[binary_comprehension,nowarn_shadow_vars]"
	    ;;
     --newbin)
            shift
            ERL_COMPILER_OPTIONS="[bitlevel_binaries,binary_comprehension,nowarn_shadow_vars]"
	    ;;
     -q)
	    shift
	    quiet=yes
	    ;;
     --quiet)
	    shift
	    quiet=yes
	    ;;
     --list)
	    echo `ls -d *_tests`
	    exit 0
	    ;;
     --default*)
	    ./alltests.sh --list
	    exit 0
	    ;;
     --help)
	    shift
	    help=yes
	    break
	    ;;
     *)
	    break
	    ;;
    esac
done

if test $# -eq 0; then
    OTP_DIR=$startdir
else
    OTP_DIR=$1
fi

##
## If something's wrong, or --help was given, print help and exit
##
if test -n "${help}" -o -z "${OTP_DIR}" -o $# -gt 1; then
  cat <<EOF
=============================================================================
 Usage: testsuite.sh [--rts_opts "rts_opts"] [--comp_opts "comp_opts"]
                     [--add "add_list"]  [--exclude "exclude_list"]
                     [--only "test_list"] [--smp] [--hybrid]
                     [--system] [--types] [--core] [--no_native] [-q|--quiet]
                     [--list] [--default] [--help] [OTP_DIR]
 where: OTP_DIR   -- directory of OTP/Erlang system; default is current dir.
        rts_opts  -- options to pass to Erlang/OTP executable
        comp_opts -- options to pass to HiPE compiler
                     when no options are given, they default to [o2]
        add       -- the list of additional tests to run
        exclude   -- the list of tests NOT to run
        only      -- the list of tests to run; replaces default,
                     both --exclude and --only can be specified at once
        smp       -- a shorthand option, equivalent to:
                       --rts_options "-smp" --exclude "${smp_excl_tests}"
        hybrid    -- a shorthand option, equivalent to:
                       --rts_options "-hybrid"
        hybrid-a  -- like the --hybrid option but with analysis enabled
	bitlevel  -- use bit-level binaries
	bincomp   -- allow binary comprehensions
        newbin    -- allow both bit-level binaries and binary comprehensions
	system    -- runs only system_tests which check consistency of HiPE;
                     it is equivalent to:
                       --comp_options "[no_native]" --only "system_tests"
	types     -- runs only tests for the type inferencer
	core      -- equivalent to:
                       --comp_options "[core]" --exclude "${core_excl_tests}"
 	no_native -- equivalent to:
                       --comp_options "[no_native]"
                       --exclude "${no_native_excl_tests}"
  	quiet     -- do not send mail to user
  	list      -- list all available test sets and exit
  	default   -- list the default test sets and exit
  	help      -- show this message and exit
=============================================================================
EOF
  exit
fi

echo "========================================================================"

#============================================================================
# Generic stuff
#============================================================================
export OTP_DIR ERL_COMPILER_OPTIONS
#============================================================================
# Some stuff necessary for running Dialyzer appear below
#============================================================================
DIALYZER_OTP=$OTP_DIR
BASE_DIR=`dirname $OTP_DIR`
DIALYZER_DIR=$BASE_DIR/dialyzer
DIALYZER_TMP=/tmp/dialyzer_tmp_dir.$USER
export DIALYZER_OTP DIALYZER_DIR DIALYZER_TMP
#============================================================================

HIPE_RTS=$OTP_DIR/bin/$erl

GREP="grep"
MSG_FILE=/tmp/hipe_test_msg.$USER
LOG_FILE=/tmp/hipe_test_log.$USER
RES_FILE=/tmp/hipe_test_res.$USER

HOSTNAME=`hostname`

if test ! -x "$HIPE_RTS"; then
    echo "Can't execute the $HIPE_RTS"
    echo "aborting..."
    echo "Can't execute $HIPE_RTS" >$MSG_FILE
    echo "Aborted testsuite on $HOSTNAME..." >> $MSG_FILE
    if test -z "$quiet"; then
	mail -s "HiPE testsuite aborted" $USER < $MSG_FILE
    fi
    rm -f $MSG_FILE
    exit
fi

lockfile=/tmp/hipe_test_lock.$USER
trap 'rm -f $lockfile; exit 1' 1 2 15
if test -f $lockfile; then
    echo "The lock file $lockfile exists."
    echo "Probably testsuite is already running."
    echo "If not, remove $lockfile"
    echo "and try again."
    echo "========================================================================"
    exit
else
    echo $$ > $lockfile
fi

if test -f "$RES_FILE"; then
  echo "There was an old $RES_FILE... removing"
  rm -f $RES_FILE
fi

if test -f "$LOG_FILE"; then
  echo "There was an old $LOG_FILE... removing"
  rm -f $LOG_FILE
fi

#-----------------------------------------------------------------------------
echo "Testing $OTP_DIR $rts_options"
if test ! -z "$comp_options"; then
  echo "Compiler options: $comp_options"
fi
if test ! -z "$only_tests"; then
  echo "* Only running: $only_tests"
fi
if test ! -z "$excluded_tests"; then
  echo "* Excluding: $excluded_tests"
fi
if test ! -z "$added_tests"; then
  echo "* Adding: $added_tests"
fi
echo "The log will be left in $LOG_FILE"

echo "Log for  : $OTP_DIR $rts_options" > $LOG_FILE
echo "Date-Time: `date +"%y%m%d-%H%M"`" >> $LOG_FILE # ` stupid emacs
echo "Testing $OTP_DIR $rts_options" > $LOG_FILE
echo "ERL_COMPILER_OPTIONS=$ERL_COMPILER_OPTIONS"

rm -f test.beam
$HIPE_RTS -make   ## This makes test.beam

rm -f core erl_crash.dump */core */erl_crash.dump

./alltests.sh --rts_opts "$rts_options" --comp_opts "$comp_options" \
	--only "$only_tests" --exclude "$excluded_tests" \
	--add "$added_tests" "$OTP_DIR" "$HIPE_RTS" >> $LOG_FILE 2>&1

touch $RES_FILE

coredumps=`find . -name core -print`
if test -n "$coredumps" ; then
  echo "The following coredumps occurred during this test run:" >> $RES_FILE
  ls -1 $coredumps >> $RES_FILE
  echo "End of the core dumps list" >> $RES_FILE
fi

erl_crashdumps=`find . -name erl_crash.dump -print`
if test -n "$erl_crashdumps" ; then
  echo "The following erl_crash.dumps occurred during this test run:" >> $RES_FILE
  ls -1 $erl_crashdumps >> $RES_FILE
  echo "End of the erl_crash.dumps list" >> $RES_FILE
fi

# This must match the message generated for diffs in test_common.sh
diffpat="differ\!\!"

# PLEASE put exact examples of what we're grepping for here, as comments!
# Also note that the search can trigger too easily on normal words,
# filenames, etc.

# check for output differences
pat="$diffpat"
# check for segmenation fault: usually appears as "Segmentation fault"
pat="${pat}\|egmentation fault"
# core dumped
pat="${pat}\|core dump"
# when no output file is generated
pat="${pat}\|EXIT"
pat="${pat}\|no match"
# for bus error
pat="${pat}\|bus err"
# for overflows
pat="${pat}\|overflow"
# for ... missing command...
pat="${pat}\|not found"
pat="${pat}\|abnorm"
pat="${pat}\|denied"
pat="${pat}\|no such file"
# The following line also matches "CosFileTransfer_IllegalOperation..."
#pat="${pat}\|illegal"    FIXME: Illegal what? 
# sometimes after overflow the diff fails and a message
# with Missing is displayed
pat="${pat}\|missing"
# for warnings that the BEAM and HiPE compiler generate
pat="${pat}\|Warning"
# Dialyzer warnings: -- apparently this line causes trouble on Solaris
## pat="${pat}\|\{*,*,*\}:"
#
pat="${pat}\|fatal"
# some other problems that should highlight bugs in the test suite
pat="${pat}\|syntax error"
pat="${pat}\|cannot find"
# reports from system_tests
pat="${pat}\|\(undefined_functions\|unused_locals\|unused_exports\)_in_hipe"
$GREP "$pat" $LOG_FILE >> $RES_FILE


# -s tests if size > 0
if test -s $RES_FILE; then
	NEW_LOG=$LOG_FILE-`date +"%y.%m.%d-%H:%M:%S"`
	NEW_RES=$RES_FILE-`date +"%y.%m.%d-%H:%M:%S"`
	cp $LOG_FILE $NEW_LOG
        # First list all differing tests as a quick summary
	echo >> $RES_FILE
	echo "------------------------------------------------------------------------"
	cat $RES_FILE | $GREP "$diffpat"
	echo "------------------------------------------------------------------------"
	echo "***FAILED testsuite for:"
	echo "   $OTP_DIR"
	echo "on $HOSTNAME"
	echo "see $NEW_RES for more details."
	if test -z "$quiet"; then
            echo "***FAILED testsuite for $OTP_DIR on $HOSTNAME" > $MSG_FILE
	    echo "Check the log file $NEW_LOG" >> $MSG_FILE
	    echo >> $MSG_FILE
	    echo "    Summary of the problems:" >> $MSG_FILE
	    echo >> $MSG_FILE
	    echo "Failing tests:" >> $MSG_FILE
	    echo >> $MSG_FILE
	    $GREP "$diffpat" $RES_FILE >> $MSG_FILE
	    echo >> $MSG_FILE
	    echo "Details:" >> $MSG_FILE
	    echo >> $MSG_FILE
	    cat $RES_FILE >> $MSG_FILE
	    mail -s "HiPE testsuite failed" $USER < $MSG_FILE
	    rm -f $MSG_FILE
	    cp $RES_FILE $NEW_RES
        else
	    echo "(See also the log file $NEW_LOG)" >> $MSG_FILE
	    echo "Failing tests:" > $NEW_RES
	    echo >> $NEW_RES
	    $GREP "$diffpat" $RES_FILE >> $NEW_RES
	    echo >> $NEW_RES
	    echo "Details:" >> $NEW_RES
	    echo >> $NEW_RES
	    cat $RES_FILE >> $NEW_RES
	    echo "Quiet mode: no mail sent."
	    echo "Summary saved in $NEW_RES"
	    echo "Log file saved in $NEW_LOG"
        fi
else
	echo "PASSED HiPE testsuite for:"
	echo "   $OTP_DIR"
	echo "on $HOSTNAME"
        rm -f $RES_FILE
fi

$GREP TESTSUITE-NOTE $LOG_FILE

rm -f $lockfile

echo "========================================================================"
