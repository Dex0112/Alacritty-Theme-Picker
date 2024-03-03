#!/bin/bash

themes_dir="$HOME/.config/alacritty/themes/themes"
alacritty_dir="$HOME/.config/alacritty/alacritty.toml"

while true; do 
    themes=("$themes_dir"/*)

    keepers=()
    remove=()

    num_themes="${#themes[@]}"

    counter=1

    echo "You have $num_themes to sort through!"

    while [ "$num_themes" -gt 0 ]; do
        theme="${themes[0]}"

        sed -i "s~$HOME/.*~$theme\"~g" "$alacritty_dir"

        echo "$theme: $counter/$num_themes"

        alacritty > /dev/null 2>&1 &

        pid=$!

        wait $pid

        echo "Alacritty has closed"

        echo "1: keep, 2: remove: 3: skip"
        read choice

        if [ "$choice" -eq 1 ]; then
            echo "your choice was 1"
            keepers+=("$theme")
        elif [ "$choice" -eq 2 ]; then
            echo "Your choice was 2"
            remove+=("$theme")
        else
            echo "Your choice was 3"
            themes+=("$theme")
        fi

        ((counter++))

        themes=("${themes[@]:1}")
    done


    echo "Would you like to remove themes (y/n)?"
    read delete_choice

    if [ "{$delete_choice,,}" = "y" ]; then
        echo "Deleting files"
        for theme in "${remove[@]}"; do
            rm -f "$themes_dir/$theme"
        done
    elif [ "${delete_choice,,}" = "n" ]; then
        echo "Not deleting files!"
    else
        echo "Option not recognized! Not deleting files!"
    fi

    echo "Would you like to do this process again with remaining files (y/N)?"
    read recurse

    if [ "$recurse" != "y" ]; then
        break;
    fi
done

echo "exiting..."
