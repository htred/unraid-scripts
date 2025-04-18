#!/bin/bash
# Script to delete files and folders in /output/trash and log details in console

TRASH_DIR="/mnt/user/downloads/_convert/trash"

function get_size_in_gb {
  local item=$1
  size=$(du -sh "$item" | awk '{print $1}')
  echo $size | awk '
    /G$/ { sub(/G$/, ""); printf "%.2f", $0 }
    /M$/ { sub(/M$/, ""); printf "%.2f", $0 / 1024 }
    !/[GM]$/ { print 0 }
  '
}

total_size_deleted_gb=0

echo "----------- Start Deletion: $(date) ------------"
echo "Items deleted:"

for item in "$TRASH_DIR"/*; do
  if [ -e "$item" ]; then
    item_size=$(get_size_in_gb "$item")
    echo "$item ($item_size GB)"
    total_size_deleted_gb=$(awk "BEGIN {print $total_size_deleted_gb + $item_size}")
    rm -rf "$item"
  fi
done

echo "Total size deleted: $total_size_deleted_gb GB"
echo "----------- End Deletion: $(date) ------------"
