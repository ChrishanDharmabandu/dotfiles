#!/bin/bash

# Detect clipboard copy command (wl-copy or xclip)
if command -v wl-copy &> /dev/null; then
  COPY_CMD="wl-copy"
elif command -v xclip &> /dev/null; then
  COPY_CMD="xclip -selection clipboard"
else
  echo "No clipboard tool found (wl-copy or xclip required)." >&2
  exit 1
fi

# Detect clipboard paste command (wl-paste or xclip)
if command -v wl-paste &> /dev/null; then
  PASTE_CMD="wl-paste"
elif command -v xclip &> /dev/null; then
  PASTE_CMD="xclip -selection clipboard -o"
else
  echo "No clipboard tool found (wl-paste or xclip required)." >&2
  exit 1
fi

# Replace this with your actual macOS SSH hostname or IP
MACOS_HOST="squishy-macos@macos-hostname"

echo "Copying Linux clipboard TO macOS clipboard..."
$PASTE_CMD | ssh "$MACOS_HOST" 'pbcopy'

echo "Copying macOS clipboard TO Linux clipboard..."
ssh "$MACOS_HOST" 'pbpaste' | $COPY_CMD

echo "Clipboard sync complete."

