#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <MAIN_CLASS> <SUBMISSION>.zip"
    echo
    echo "Example: $0 com.example.some.package.ProgrammingAssignment Gruppe_01--prg-assignment01.zip"
    exit 1
fi

# register trap for ctrl-c
trap quit INT

class="$(echo $1 | sed 's#\.#/#g').java"
clazz="$(echo $1 | sed 's#\.#/#g').class"

checkfile="$(pwd)/hashes.txt"

dir=$(mktemp -d)

function quit() {
    echo "Exiting and cleaning up..."

    cd /
    rm -fr "$dir"
    echo "Bye have a great time!"
    exit 0
}

echo "Extracting submission..."

cp "$2" "$dir"
cd "$dir"
unzip -U "$2"

echo "Looking for class containing the main method..."

find . -print0 | grep -FzZ "$class"

if [ "$?" -ne 0 ]; then
    echo "Error: 404 Class not found..."
    exit 2
fi
echo

echo "Compiling submission..."
cpath=$(find . -print0 | grep -FzZ "$class" | sed 's/\x0//g')

cd ${cpath%$class}
javac "$class"

echo "Checking for plagiarism..."

hashsum=$(sha1sum "$class" | awk '{ print $1 }')
cat $checkfile | grep $hashsum
if [ "$?" -ne 0 ]; then
    echo "No plagiarism found..."
    echo "$hashsum $2" >> $checkfile
else
    echo "Error: Plagiarism found!!!"
    echo "Press enter to continue..."
    read
fi

echo "Finished compiling!"
echo

while true; do
    echo "What do you want to do with the submission ${1}?"
    echo
    echo " l  list all source code files"
    echo " e  view a source code file (defaults to main class)"
    echo " c  recompile the main class"
    echo " x  execute the main method"
    echo " q  quit and remove temporary files"
    echo

    read -p " > " input
    case $input in
        [lL]* )
            tree .
            ;;
        [eE]* ) 
            $EDITOR "$class" ${input:2}
            ;;
        [cC]* ) 
            javac "$class"
            ;;
        [xX]* ) 
            echo "executing main method... (can be terminated with ctrl+c)"
            java "$1" ${input:2}
            ;;
        [qQ]* ) 
            quit
            ;;
        * ) 
            echo "Invalid input!";;
    esac
done
