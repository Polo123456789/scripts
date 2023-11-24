#!/bin/bash

# xdg-open "$(zenity --file-selection)"

SELECTION=""
CURRENT_DIRECTORY="$HOME"

while [ ! -f "$SELECTION" ]; do
    cd "$CURRENT_DIRECTORY"
    SELECTION=$(ls -1a | dmenu -i -p "File:" -l 15)
    if [ -d "$SELECTION" ]; then
        CURRENT_DIRECTORY="$SELECTION"
    elif [ -f "$SELECTION" ]; then
        xdg-open "$SELECTION"
    else
        exit 0
    fi
done
