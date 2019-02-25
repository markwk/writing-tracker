#!/bin/bash
##################################
#
# WRITING TRACKER
#
# More Info at https://github.com/markwk/writing-tracker
#
# INTRODUCTION: 
# Daily script to navigate to a directory of plain text files,
# add files to git repo, calculate key diff stats, store stats to csv
# and commit to git with message  
# 
# Optional: 
# * Send a local mac push notification. 
# * Track actual files directory of copy files to a new dirctory for tracking
#
# Designed to help track writing and notes files in in plaintext
# it should work with any directory of plain text files. 
#
# by Mark Koester 
# github.com/markwk
# markwkoester@gmail.com 
# 
##################################
# SETUP 
# [If haven't already, install git locally]
#
# 1. Either make your current files directory git repo
# Or create a copy directory of files and make it a git repo
#
# 2. Copy this script and create file into a local directory as archive-daily-git-commit.bash 
# 3. Make file executable by setting permissions with commmand:
# $ chmod +x archive-daily-git-commit.bash
# 
# 4. Configure Directory references below. 
# 5. Edit cron to run daily by running command:
# $ crontab -e
# add line like this which runs at 1am daily:
# 00  1  *  *  * /path/to/bash/archive-daily-git-commit.bash
#
##################################
# CONFIGURATION
#
# Uncomment and set your target directories.
#
# ARCHIVE_DIR=/Users/markkoester/Library/Mobile' 'Documents/9CR7T2DMDG~com~ngocluu~onewriter/Documents/Notes_TheArchive/
# COPIED_DIR="/Users/markkoester/Development/bash/the_archive_writings_tracking_repo/"
# Name of Directory with files we will be tracking
TARGET_DIR=/Users/markkoester/Library/Mobile' 'Documents/9CR7T2DMDG~com~ngocluu~onewriter/Documents/Archive/
# Name of daily stats file
DATA_FILE="/Users/markkoester/Development/bash/writing-notes-stats.csv"
#
##################################

CURRENTDATETIME=`date +"%Y-%m-%d %T"`
CURRENTDATE=`date +"%Y-%m-%d"`
YESTERDAY=`date -v-1d +%F`

# Copy files from current directory into repo
# Uncomment to remove copying
#cd "$ARCHIVE_DIR" 
#cp -fp * $COPIED_DIR

# Navigate to target directory and start git staging
# cd $COPIED_DIR
cd "$TARGET_DIR"
git add .

# Run our analysis and post to some log messages. 
echo "Writing Stats Analysis for ${CURRENTDATETIME}"

# File Counts 
total_files="$(ls -1q * | wc -l | tr -d '[:space:]')"
files_changed="$(git status | wc -l | tr -d '[:space:]')"
files_added="$(git status | grep 'new file' | wc -l | tr -d '[:space:]')"
files_modified="$(git status | grep 'modified' | wc -l | tr -d '[:space:]')"
files_deleted="$(git status | grep 'deleted' | wc -l | tr -d '[:space:]')"
files_renamed="$(git status | grep 'renamed' | wc -l | tr -d '[:space:]')"
echo "Files: total files: $total_files, total changed: $files_changed, added " $files_added, "modified " $files_modified, "deleted " $files_deleted,  "renamed" $files_renamed

# Word Counts | Credit: https://gist.github.com/MilesCranmer/5c7d86c8740219355d2dfdb184910711
words_added=$(git diff --cached --word-diff=porcelain |grep -e"^+[^+]"|wc -w|xargs)
words_deleted=$(git diff --cached --word-diff=porcelain |grep -e"^-[^-]"|wc -w|xargs)
words_duplicated=$(git diff --cached |grep -e"^+[^+]" -e"^-[^-]"|sed -e's/.//'|sort|uniq -d|wc -w|xargs)
echo "Words: added " $words_added, "deleted " $words_deleted, "duplicated" $words_duplicated

# hashtag counts (note: excluding hashed tagged words like #1234)
hashtags_added=$(git diff --cached --word-diff=porcelain | grep -e"^+" | grep -o '#[a-zA-Z]\+'|wc -w|xargs)
hashtags_deleted=$(git diff --cached --word-diff=porcelain | grep -e"^-" | grep -o '#[a-zA-Z]\+'|wc -w|xargs)
echo "Hashtags: added " $hashtags_added, "deleted " $hashtags_deleted

# Count of citations references in special format like #123.
# Used in the case of a reference manager like Bookends or Zotero. 
refs_added=$(git diff --cached --word-diff=porcelain | grep -e"^+" | grep -o '#[0-9_]\+'|wc -w|xargs)
refs_deleted=$(git diff --cached --word-diff=porcelain | grep -e"^-" | grep -o '#[0-9_]\+'|wc -w|xargs)
echo "References: added " $refs_added, "deleted " $refs_deleted

# FUTURE TODO: Loop through all modified files and get list of hashtag and count on active files
#  for x in "$(git status -s | grep -o '".*"' | tr -d '"' )"; do 
   #name=$($x | tr -d '"')
   #file="$ARCHIVE_DIR$x"
   #x+=
#   echo "$x"
   #open ""$x"" #| grep -o '#[a-zA-Z]\+'
#done

# Save stats as new line with date to local csv
echo ${YESTERDAY}, ${CURRENTDATETIME}, $total_files, $files_changed, $files_added, $files_modified, $files_deleted, $files_renamed, $words_added, $words_deleted, $words_duplicated, $hashtags_added, $hashtags_added, $hashtags_deleted, $refs_added, $refs_deleted >> $DATA_FILE

# Commit Changes to Git with Custom Message
commit_msg=("$YESTERDAY Daily Writing Stats: Words Added: $words_added, Files Added: $files_added")
echo $commit_msg
# uncomment after testing
# git commit -m "$commit_msg"
# uncomment to then push changes to remote repo
# git push origin master

# Optional for Mac
# uncomment to send a mac notification message
# osascript -e 'display notification "Successfully copied writing files and logged stats into git." with title "Yesterday Daily Writing Stats Saved"'

# FUTURE TODO: [Possible] Curl to save stats to a google sheet or another tracking api
# SEE: https://productforums.google.com/forum/#!topic/docs/18vuCI8Me10
# https://gist.github.com/joebuhlig/b0c3cd227c148685f98d/raw/74ee50a30b9b0857f251c5d753573a4ae4a6ecfa/Git%20Writing%20Tracker%20Post-Commit
