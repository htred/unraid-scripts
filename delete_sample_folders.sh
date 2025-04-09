#!/bin/bash

# === Configuration ===
DRYRUN=true
BASE_DIR="/mnt/user/media"
TARGET_NAMES=("Sample" "sample")
# =====================

echo "Configuration:"
echo "Dry Run: $DRYRUN"
echo "Base Directory: $BASE_DIR"
echo "Target Files: ${TARGET_NAMES[*]}"
echo "--------------------------"

echo "Searching for (and optionally deleting) target folders"
echo "This may take a while..."

COUNT=0

FIND_EXPR=()
for NAME in "${TARGET_NAMES[@]}"; do
    FIND_EXPR+=(-name "$NAME" -o)
done
unset 'FIND_EXPR[${#FIND_EXPR[@]}-1]'  # Letztes "-o" entfernen

mapfile -d '' DIRS < <(find "$BASE_DIR" -type d \( "${FIND_EXPR[@]}" \) -print0)

for DIR in "${DIRS[@]}"; do
    SUBDIR_COUNT=$(find "$DIR" -mindepth 1 -type d | wc -l)

    if [[ "$SUBDIR_COUNT" -eq 0 ]]; then
        if [ "$DRYRUN" = true ]; then
            echo "Would delete folder: $DIR"
        else
            echo "Deleting folder: $DIR"
            rm -r "$DIR"
        fi
        ((COUNT++))
    else
        echo "Skipped (has subfolders): $DIR"
    fi
done

if [ "$DRYRUN" = true ]; then
    echo "Done. Found $COUNT folder(s) that would have been deleted (dry run)."
else
    echo "Done. Deleted $COUNT folder(s) without subfolders."
fi
