#!/bin/bash

# === Configure your remote hosts ===
REMOTE_HOST_MACOS="squishy-macos@squishym1.local"
REMOTE_HOST_LINUX="squishy@arch-beast.local"

# Detect OS type
OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  # Running on macOS
  LOCAL_OS="macos"
  REMOTE_HOST="$REMOTE_HOST_LINUX"
elif [[ "$OS" == "Linux" ]]; then
  # Running on Linux
  LOCAL_OS="linux"
  REMOTE_HOST="$REMOTE_HOST_MACOS"
else
  echo "Unsupported OS: $OS"
  exit 1
fi

# --- Define clipboard commands for macOS ---
macos_copy() { pbcopy; }
macos_paste() { pbpaste; }

# --- Define clipboard commands for Linux ---
detect_linux_clipboard_cmds() {
  if command -v wl-copy &>/dev/null && command -v wl-paste &>/dev/null; then
    COPY_CMD="wl-copy"
    PASTE_CMD="wl-paste"
  elif command -v xclip &>/dev/null; then
    COPY_CMD="xclip -selection clipboard"
    PASTE_CMD="xclip -selection clipboard -o"
  else
    echo "No suitable clipboard utilities found on Linux (need wl-copy/wl-paste or xclip)."
    exit 1
  fi
}

# --- Functions to copy/paste locally based on OS ---
copy_local() {
  if [[ "$LOCAL_OS" == "macos" ]]; then
    macos_copy
  else
    $COPY_CMD
  fi
}

paste_local() {
  if [[ "$LOCAL_OS" == "macos" ]]; then
    macos_paste
  else
    $PASTE_CMD
  fi
}

# --- Main logic ---
if [[ "$LOCAL_OS" == "linux" ]]; then
  detect_linux_clipboard_cmds
fi

echo "Syncing clipboard between $LOCAL_OS and remote..."

if [[ "$LOCAL_OS" == "linux" ]]; then
  # Linux -> macOS
  paste_local | ssh -T "$REMOTE_HOST" "pbcopy"
  # macOS -> Linux
  ssh -T "$REMOTE_HOST" "pbpaste" | copy_local
else
  # macOS -> Linux
  paste_local | ssh -T "$REMOTE_HOST" "$COPY_CMD"
  # Linux -> macOS
  ssh -T "$REMOTE_HOST" "$PASTE_CMD" | macos_copy
fi

echo "Clipboard sync complete."

