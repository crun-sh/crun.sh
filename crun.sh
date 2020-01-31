#!/bin/sh

set -e

#if [[ "$(docker images -q crun-sh/crun:latest 2> /dev/null)" == "" ]]; then
#  echo "crun image not found, downloading"
#fi

while getopts 'uvwi:r:l:' c
do
  case $c in
    u) UPDATE=yes ;;
    i) INSTALL+="$OPTARG " ;;
    r) REMOVE+="$OPTARG " ;;
    l) LAUNCH="$OPTARG" ;;
    v) VERBOSE="yes" ;;
    w) VERYVERBOSE="yes" ;;
  esac
done

# Remove all options and leave $@ with any leftover args
shift $((OPTIND-1))
if [ $VERYVERBOSE ]; then
  set -x
fi

DRUN="docker run --rm -v $HOME/.crun:/config"

if [ -n "$UPDATE" ]; then
  $($DRUN davidsiaw/crun update > .tmp)
fi

if [ -n "$INSTALL" ]; then
  $($DRUN davidsiaw/crun install $INSTALL > .tmp)
fi

if [ -n "$REMOVE" ]; then
  $($DRUN davidsiaw/crun remove $REMOVE > .tmp)
fi

if [ -n "$LAUNCH" ]; then
  $($DRUN davidsiaw/crun launch $LAUNCH "$@" > .tmp)
fi

if [ -n "$VERBOSE" ]; then
  cat .tmp
fi

if [[ -f ".tmp" ]]; then
  sh .tmp
  rm .tmp
fi
