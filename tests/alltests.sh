#! /bin/sh 

## File:      alltests.sh
## Author(s): Kostis Sagonas
##
## $Id: alltests.sh,v 1.23 2008/08/29 13:25:13 kostis Exp $
##
## Run with no options for usage/help.

default_testlist="trivial_tests basic_tests bench_tests big_tests bs_tests core_tests distr_tests loader_tests native_tests process_tests"

## memory_tests disabled pending resurrection of hybrid heap
#default_testlist="$default_testlist memory_tests"

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
     --list*)
	    echo $default_testlist
	    exit 0
	    ;;
      *)
	    break
	    ;;
    esac
done

if test -z "$1" -o $# -gt 2; then
  echo " Usage: alltests.sh [--rts_opts rts_opts] [--comp_opts comp_opts]"
  echo "                    [--only \"test_list\"] [--add \"added_tests\"]"
  echo "                    [--exclude \"excl_list\"] hipe_rts hipe_comp"
  echo " where: rts_opts   -- options to pass to the HiPE executable"
  echo "        comp_opts  -- options to pass to the HiPE compiler"
  echo "        only_list  -- run only this list of tests"
  echo "        add_list   -- list of additional tests to run"
  echo "        excl_list  -- quoted, space-separated list of tests to NOT run"
  echo "        hipe_rts   -- full path name of the HiPE executable (required)"
  echo "        hipe_comp  -- full path name of the HiPE compiler (required)"
  echo " NOTE: hipe_rts & hipe_comp must appear in this order!"
  exit
fi

OTP_DIR=$1
HIPE_RTS=$2
if [ -z "$HIPE_RTS" ]; then
    HIPE_RTS=$OTP_DIR/bin/erl
fi

# ---------------------------------------------------------------------
# Tests if element is a member of a list of tests
# $1 - element
# $2 - exclude list
#
member ()
{
    for elt in $2 ; do
	if test "$1" = "$elt" ; then
	    return 0
	fi
    done
    return 1
}
#
# Constructs the test list by removing elements of the excluded list
# $1 - preliminary test list
# $2 - exclude list
#
construct_tests ()
{
    tests=""
    for elt in $1 ; do
      if member "$elt" "$2" ; then
	continue
      else
	tests="$elt $tests"
      fi
    done
    return "$tests"
}
# ---------------------------------------------------------------------

echo "------------------------------------------------------------------------"
echo "---                     Running alltests.sh                          ---"
echo "------------------------------------------------------------------------"

if test -z "$only_tests"; then
  testlist="$default_testlist $added_tests"
else
  testlist=$only_tests
fi
echo "Will be testing:" $testlist
if test ! -z "$excluded_tests"; then
  echo "however skipping:" $excluded_tests
fi

##
## Run each test in $testlist except for the tests in $excluded_tests
##
for tstdir in $testlist ; do
  if member "$tstdir" "$excluded_tests" ; then
    continue
  else
    cd $tstdir
    if test -f core ; then
	rm -f core
    fi
    if test -f erl_crash.dump ; then
	rm -f erl_crash.dump
    fi
    if member "$tstdir" "typesig_tests" ; then
      ./test.sh "$OTP_DIR"
    else
      ./test.sh "$HIPE_RTS" "$comp_options" "$rts_options"
    fi
    cd ..
  fi
done

# ---------------------------------------------------------------------
