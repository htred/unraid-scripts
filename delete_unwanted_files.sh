#!/bin/bash

# === Configuration ===
DRYRUN=true
BASE_DIR="/mnt/user/media"
TARGET_NAMES=(".DS_Store" "Thumbs.db", "*.url")
# =====================

echo "Configuration:"
echo "Dry Run: $DRYRUN"
echo "Base Directory: $BASE_DIR"
echo "Target Files: ${TARGET_NAMES[*]}"
echo "--------------------------"

echo "Searching for (and optionally deleting) specified files"
echo "This may take a while..."

COUNT=0


FIND_EXPR=()
for NAME in "${TARGET_NAMES[@]}"; do
    FIND_EXPR+=(-name "$NAME" -o)
done
unset 'FIND_EXPR[${#FIND_EXPR[@]}-1]'

while IFS= read -r -d '' FILE; do
    if [ "$DRYRUN" = true ]; then
        echo "Would delete: $FILE"
    else
        echo "Deleting: $FILE"
        rm "$FILE"
    fi
    ((COUNT++))
done < <(find "$BASE_DIR" -type f \( "${FIND_EXPR[@]}" \) -print0)

if [ "$DRYRUN" = true ]; then
    echo "Done. Found $COUNT file(s) that would have been deleted (dry run)."
else
    echo "Done. Deleted $COUNT file(s)."
fi
