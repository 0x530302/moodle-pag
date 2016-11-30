# moodle-pag
moodle-pag is little shell script that helps to grade zipped (java) programming assignments (e.g. Eclipse or IntelliJ projects) that were previously downloaded from moodle.
Works great in combination with the awesome [moodle destroyer tools](https://github.com/manly-man/moodle-destroyer-tools).

# Installation
Just clone the repo and symlink or copy the shell script in some directory that belongs to your `$PATH`:
```
sudo ln -s $PWD/pag.sh /usr/local/bin/pag
```

# Usage
```
Usage: /usr/local/bin/pag <MAIN_CLASS> <SUBMISSION>.zip

Example: /usr/local/bin/pag com.example.some.package.ProgrammingAssignment Gruppe_01--prg-assignment01.zip
```

Call the tool once, for every submission and provide the class name that should contain the main method.

You are then prompted with some options to view that assignment.
```
What do you want to do with the submission com.example.some.package.ProgrammingAssignment?

 l  list all source code files
 e  view a source code file (defaults to main class)
 c  recompile the main class
 x  execute the main method
 q  quit and remove temporary files
```

# Notice
This script is still work in progress, is open to suggestion and has most certainly many bugs.
