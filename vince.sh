#!/bin/bash

if [ "$#" -ne 7 ]
then
    >&2 echo "Pass 7 input images as arguments"
    exit 1
fi

vincesize="362x270!"

workdir="$(mktemp -d)"

joincommand="convert "
i=1
for input in "$@"
do
    # Resize to fit vince exactly
    convert "$input" -resize "$vincesize" "${workdir}/${input}.png"
    # Convert to still 1s gif 
    convert -delay 100 -loop 0 "${workdir}/${input}.png" "${workdir}/${input}.gif"
    # Build up final conversion command
    joincommand="${joincommand}${workdir}/${input}.gif ${i}.gif "
    ((++i))
done
joincommand="${joincommand}output.gif"
eval "${joincommand}"
rm -rf "$workdir"
