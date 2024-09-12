#!/bin/bash

SOURCE="$HOME/.tmux/.tmux.conf"
TARGET="$HOME/.tmux.conf"

if [ -e "$SOURCE" ]; then
    ln -s -f "$SOURCE" "$TARGET"
    echo "Symbolic link created successfully: $TARGET -> $SOURCE"
else
    echo "Source file $SOURCE does not exist."
fi