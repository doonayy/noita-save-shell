#!/bin/bash

# Paths, you should edit that, i doubt you want your saves on your desktop.
GAME_SAVE_PATH="$HOME/.local/share/Steam/steamapps/compatdata/881100/pfx/drive_c/users/steamuser/AppData/LocalLow/Nolla_Games_Noita/"
BACKUP_PATH="$HOME/Desktop/noita_save/"

# backup game data
backup_game() {
  echo "Backing up your game..."
  mkdir -p "$BACKUP_PATH" # making sure it exists

  # hacky way to make a new save
  last_backup=$(find "$BACKUP_PATH" -name "save00_*" | sort -V | tail -n 1)
  if [[ -n $last_backup ]]; then
    next_backup_number=$(basename "$last_backup" | sed -E 's/save00_([0-9]+)/\1/' | awk '{print $1 + 1}')
  else
    next_backup_number=1
  fi

  cp -r "${GAME_SAVE_PATH}save00" "${BACKUP_PATH}save00_$next_backup_number"
  echo "Backup completed successfully as save00_$next_backup_number."
}

# loading the save
load_backup() {
  echo "Available backups:"
  ls "$BACKUP_PATH" | grep "save00_"
  read -p "Enter the backup number to load (1 for save00_1...): " backup_number

  selected_backup="${BACKUP_PATH}save00_$backup_number"
  if [[ -d $selected_backup ]]; then
    echo "Loading your backup..."
    rm -rf "${GAME_SAVE_PATH}save00" # Remove old game data
    cp -r "$selected_backup" "${GAME_SAVE_PATH}save00"
    echo "Backup loaded."
  else
    echo "Backup not found."
  fi
}

# deleting backup
delete_backup() {
  echo "Backups to delete:"
  ls "$BACKUP_PATH" | grep "save00_"
  read -p "Enter the backup number to delete (1 for save00_1...): " backup_number_to_delete

  selected_backup_to_delete="${BACKUP_PATH}save00_$backup_number_to_delete"
  if [[ -d $selected_backup_to_delete ]]; then
    echo "Deleting your backup..."
    rm -rf "$selected_backup_to_delete"
    echo "Backup deleted."
  else
    echo "Backup not found."
  fi
}

# menu
echo "Please choose an option:"
echo "1) Backup your game"
echo "2) Load your backup"
echo "3) Delete a backup"
read -p "Enter your choice (1, 2, or 3): " user_choice

# inputs
case $user_choice in
1)
  backup_game
  ;;
2)
  load_backup
  ;;
3)
  delete_backup
  ;;
*)
  echo "Invalid choice. Please run the script again and select either 1, 2, or 3."
  ;;
esac
