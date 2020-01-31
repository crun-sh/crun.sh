#!/bin/sh

set -e

#if [[ "$(docker images -q crun-sh/crun:latest 2> /dev/null)" == "" ]]; then
#  echo "crun image not found, downloading"
#fi

while getopts 'vwu:i:r:l:s:q:' c
do
  case $c in
    u) UPDATE+="$OPTARG ";;
    i) INSTALL+="$OPTARG " ;;
    r) REMOVE+="$OPTARG " ;;
    l) LAUNCH="$OPTARG" ;;
    v) VERBOSE="yes" ;;
    w) VERYVERBOSE="yes" ;;
    s) SHOW="$OPTARG" ;;
    q) QUERY="$OPTARG" ;;
  esac
done

DRUN="docker run --rm -v $HOME/.crun:/root/.crun"

if [ -n "$UPDATE" ]; then
  $($DRUN crunsh/crun update $UPDATE > .tmp)
fi

if [ -n "$INSTALL" ]; then
  $($DRUN crunsh/crun install $INSTALL > .tmp)
fi

if [ -n "$REMOVE" ]; then
  $($DRUN crunsh/crun remove $REMOVE > .tmp)
fi

if [ -n "$LAUNCH" ]; then
  $($DRUN crunsh/crun launch $LAUNCH "$@" > .tmp)
fi

if [ -n "$QUERY" ]; then
  $($DRUN crunsh/crun query $QUERY "$@" > .tmp)
fi

if [ -n "$VERBOSE" ]; then
  cat .tmp
fi

if [ -n "$SHOW" ]; then
  echo "Available versions of '$SHOW':"
  cd "$HOME/.crun/apps/" && ls "$SHOW-"*
fi

if [[ -f ".tmp" ]]; then
  sh .tmp
  rm .tmp
fi
