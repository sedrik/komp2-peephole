## Produces a log file to help finding out what went wrong in a test run.

files=`ls *new*`

if test -f log; then
    echo "Removing old log file"
    rm log
fi

echo "Leaving result in the file: log"
touch log

for f in $files;do 
    name=`echo $f | sed s/"_new.*"//`
    old_file=${name}_old
    echo >>log;
    echo "File: ${name}" >> log; 
    echo >>log;
    echo "New result:">>log
    echo >>log;
    cat $f >> log;
    echo >>log;
    echo ----------------------------------------------------->>log;
    echo >>log;
    if test -f $old_file; then
	echo "Old result:">>log
	echo >>log;
	cat $old_file>>log
	echo >> log
	echo ----------------------------------------------------->>log;
	echo >> log
	echo "Diff:" >>log
	diff $f $old_file >> log
    else
	echo "No old result file found" >> log
    fi
    echo >>log;
    echo ===================================================>>log;
done
