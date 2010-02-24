#!/bin/sh

##-------------------------------------------------------------------
## Takes path to OTP as argument. Prints emulator and native result.
## The file is currently NOT USED. The proper way to run the test
## for external_pids is by running it through test.sh.
##-------------------------------------------------------------------

BASENAME=external_pids
S_HOSTNAME=`uname -n | sed 's/\([^.]*\)\..*/\1/'`

$1/bin/erlc $BASENAME.erl > /dev/null
$1/bin/erl -sname bar -noshell -s $BASENAME b foo@$S_HOSTNAME &
$1/bin/erl -sname foo -noshell -s $BASENAME a > .tmp.emu_res

$1/bin/erlc +native external_pids.erl > /dev/null
$1/bin/erl -sname bar -noshell -s $BASENAME b foo@$S_HOSTNAME &
$1/bin/erl -sname foo -noshell -s $BASENAME a > .tmp.native_res

cat .tmp.emu_res .tmp.native_res
rm -f .tmp.emu_res .tmp.native_res

