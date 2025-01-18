#!/bin/bash
if [ $1 = -l ]
then
    /bin/cowsay $@
else
    /bin/cowsay $@ | lolcat --force
fi