#!/bin/zsh

# Alias management script for ~/.alias

# Define the alias file as ~/.alias
ALIAS_FILE="${HOME}/.alias"

# Ensure the alias file exists, create if not
touch "$ALIAS_FILE"

# --- Input Validation ---
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $(basename "$0") <alias_name> \"<command_to_alias>\""
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") gs \"git status\""
    echo "  $(basename "$0") ll \"ls -laF\""
    echo "  $(basename "$0") cddl \"cd ~/Downloads\""
    exit 1
fi

ALIAS_NAME="$1"
COMMAND_TO_ALIAS="$2"

# --- Add Alias ---
echo "alias $ALIAS_NAME=\"$COMMAND_TO_ALIAS\"" >> "$ALIAS_FILE"
echo "Alias '$ALIAS_NAME' added to $ALIAS_FILE"

# --- Prompt to Source ---
# This part assumes your ~/.zshrc sources ~/.alias
read -q "REPLY?Source ~/.zshrc now to apply changes? (y/N) "
echo # Newline after the prompt

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    # Source your main Zsh config, which should in turn source your ~/.alias file
    source "${HOME}/.zshrc"
    echo "~/.zshrc sourced. Alias '$ALIAS_NAME' is now available."
else
    echo "Changes will apply in new terminal sessions, or when you manually source ~/.zshrc."
fi

exit 0
