#!/bin/bash

# xdg-open "$(zenity --file-selection)"

SELECTION=""
CURRENT_DIRECTORY="$HOME"

get_options() {
    if [ "$CURRENT_DIRECTORY" = "$HOME" ]; then
        echo "@clipboard"
    fi
    ls -1a
}

while [ ! -f "$SELECTION" ]; do
    cd "$CURRENT_DIRECTORY"
    SELECTION=$(get_options | dmenu -i -p "File:" -l 15)
    if [ "$SELECTION" = "@clip" ] || [ "$SELECTION" = "@clipboard" ]; then
        xdg-open "$(xclip -o -selection clipboard)"
        exit 0
    elif [ -d "$SELECTION" ]; then
        CURRENT_DIRECTORY="$SELECTION"
    elif [ -f "$SELECTION" ]; then
        xdg-open "$SELECTION"
        exit 0
    else
        exit 0
    fi
done
