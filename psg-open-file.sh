#!/bin/bash

# xdg-open "$(zenity --file-selection)"

SELECTION=""
CURRENT_DIRECTORY="$HOME"

get_options() {
    if [ "$CURRENT_DIRECTORY" = "$HOME" ]; then
        echo "@clipboard"
    fi
    echo "@list_all"
    echo "@open_dir"
    ls -1a
}

while [ ! -f "$SELECTION" ]; do
    cd "$CURRENT_DIRECTORY"
    SELECTION=$(get_options | dmenu -i -p "File:" -l 15)
    if [ "$SELECTION" = "@clip" ] || [ "$SELECTION" = "@clipboard" ]; then
        xdg-open "$(xclip -o -selection clipboard)"
        exit 0
    elif [ "$SELECTION" = "@list_all_files" ]; then
        all_files=$(find . -type f | sed 's|./||')
        SELECTION=$(echo -e "$all_files" | dmenu -i -p "File:" -l 15)
        if [ -z "$SELECTION" ]; then
            exit 0
        fi
        xdg-open "$SELECTION"
    elif [ "$SELECTION" = "@open_directory" ]; then
        xdg-open .
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
