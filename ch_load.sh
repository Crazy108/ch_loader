#!/bin/bash
CWD=$PWD

#Import settings from .env file
[[ -f .env ]] && source .env

#Exit if storage is emзty
if [ -z "$STORAGE" ]; then exit 1; fi

#Check if exists storage directory
if [ ! -d "$STORAGE" ]; then mkdir "$STORAGE"; fi

FILES=./sources/*.html
for f in $FILES; do
  echo "Processing $f file..."
  if [ ! -f "$f" ]; then continue; fi

  FILE_FNAME=`basename "$f" .html`
  CONTAINER=$STORAGE/$FILE_FNAME

  #Check if exists course container in storage directory
  if [ ! -d "$CONTAINER" ]; then mkdir "$CONTAINER"; fi

  cat "$f" | grep 'itemprop="contentUrl' | grep -Eo 'href="[^"]*.mp4' | cut -d\" -f2- > "$CONTAINER/videos.txt"
  cat "$f" | grep -Eo 'href="[^"]*.zip' | cut -d\" -f2- > "$CONTAINER/sources.txt"

  cd "$CONTAINER"
  wget --no-check-certificate -c -i videos.txt > log.log
  wget --no-check-certificate -c -i sources.txt > log.log
  cd "$CWD"
done

echo "Done"
