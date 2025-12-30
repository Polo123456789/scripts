#!/bin/bash


# Has the time and directory of the last run
# If the script is run again within 1 minute, it opens the last directory again
LAST_RUN_FILE="$HOME/scripts/.logs/psg-open-file-last-run"

LAST_RUN_TIME=0
LAST_RUN_DIR="$HOME"

if [ -f "$LAST_RUN_FILE" ]; then
    LAST_RUN_TIME=$(cut -d' ' -f1 "$LAST_RUN_FILE")
    LAST_RUN_DIR=$(cut -d' ' -f2- "$LAST_RUN_FILE")
fi


SELECTION=""
CURRENT_DIRECTORY="$HOME"
CURRENT_TIME=$(date +%s)

if [ $((CURRENT_TIME - LAST_RUN_TIME)) -le 60 ]; then
    CURRENT_DIRECTORY="$LAST_RUN_DIR"
fi


get_options() {
    if [ "$CURRENT_DIRECTORY" = "$HOME" ]; then
        echo "@clipboard"
    fi
    echo "@list_all"
    echo "@open_dir"
    ls -1a
}

save_run() {
    echo "Saving run: $CURRENT_TIME $CURRENT_DIRECTORY"
    echo "$CURRENT_TIME $CURRENT_DIRECTORY" > "$LAST_RUN_FILE"
}


while [ ! -f "$SELECTION" ]; do
    cd "$CURRENT_DIRECTORY"
    SELECTION=$(get_options | rofi -dmenu -i -p "File" -l 15)
    if [ "$SELECTION" = "@clip" ] || [ "$SELECTION" = "@clipboard" ]; then
        # TODO: Replace with wl-paste tool, e.g. xdg-open "$(wl-paste)"
        xdg-open "$(xclip -o -selection clipboard)"
        exit 0
    elif [ "$SELECTION" = "@list_all" ]; then
        all_files=$(find . -type f | sed 's|./||')
        SELECTION=$(echo -e "$all_files" | rofi -dmenu -i -p "File" -l 15)
        if [ -z "$SELECTION" ]; then
            exit 0
        fi
        save_run
        xdg-open "$SELECTION"
    elif [ "$SELECTION" = "@open_dir" ]; then
        save_run
        xdg-open .
        exit 0
    elif [ -d "$SELECTION" ]; then
        CURRENT_DIRECTORY=$(realpath "$SELECTION")
    elif [ -f "$SELECTION" ]; then
        save_run
        xdg-open "$SELECTION"
        exit 0
    else
        exit 0
    fi
done
