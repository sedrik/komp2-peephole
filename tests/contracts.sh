#!/bin/bash

usage()
{
    echo "Usage:"
    echo ""
    echo "[-o OTP_DIR]        Erlang/OTP base directory. Default 'pwd'/../otp"
    echo "[-c CONTRACTS_DIR]  Contracts directory. Default 'pwd'/../contracts"
    echo "[-f FILE]           Only files called FILE (use DIR for directory)"
    echo "[-d DIR]            Only run contract checking for directory DIR"
    echo ""
    echo "Note: You can add symlinks to the various directories so you don't "
    echo "      have to use the flags."
}

while getopts "ho:c:f:d:p:" Option
do
  case $Option in
      o     ) otp_dir=${OPTARG};;
      c     ) contracts_dir=${OPTARG};;
      f     ) files=${OPTARG};;
      d     ) DIR=${OPTARG};;
      p     ) PA=${OPTARG};;
      h     ) usage; exit;;
  esac
done
shift $(($OPTIND - 1))

if [ -z $otp_dir ]; then otp_dir=`pwd`/../otp; fi
if [ ! -d $otp_dir ]; then
    echo "No directory $otp_dir. Please supply an otp_dir using -o."
    usage; exit 1
fi
pushd $otp_dir >/dev/null && otp_dir=`pwd` && popd >/dev/null || \
    (echo "Failed to pushd/popd into $otp_dir" && usage && exit 1)
if [ -z $contracts_dir ]; then contracts_dir=`pwd`/../contracts; fi
if [ ! -d $contracts_dir ]; then
    echo "No directory $contracts_dir. Please add a contracts_dir using -c."
    usage; exit 1
fi
if [[ -n $DIR && ! -d $DIR ]]; then
    echo "Nu such directory $DIR. Remove -d flag or try again."
    usage; exit 1
fi
erl="$otp_dir/bin/erl"
erlc="$otp_dir/bin/erlc"
ERLC_FLAGS="-W +debug_info"
for dir in ${DIR:-checker_tests};
do
    echo "Entering $dir"
    cd ${dir}
    for file in ${files:-*.erl}; do
	$erlc $ERLC_FLAGS $file
	if [[ $file == "test.erl" ]]; then
	    echo "Ignoring test.erl"
	else
	    echo -n "$dir/$file: "
	    module=$(echo $file | sed 's/.erl//')
	    $erl -kernel error_logger '{file,"'$module'.log"}' \
		-pa ${PA} \
		-pa ./ -pa ${contracts_dir}/lib/*/ebin -noshell \
		-run checker run ${module} test []. -s init stop \
		> ${module}_new \
		#2> /dev/null
	    echo "done"
	    [ -f ${module}_old ] || touch ${module}_old
	    diff ${module}_old ${module}_new
	    [ -f ${module}.log.old ] || touch ${module}.log.old
	    diff -I "=.*==== .*-.*-.*::.*===" \
		${module}.log.old ${module}.log
	fi
    done
    cd ..
done
