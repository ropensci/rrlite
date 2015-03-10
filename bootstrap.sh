#!/bin/sh
RLITE=src/rlite

RLITE_COPYING=inst/rlite.COPYING

mkdir -p $(dirname $RLITE_COPYING)
echo \
"The following license applies to code from the rlite library which\n"\
"will be linked into the installed package:\n" > inst/rlite.COPYING
cat $RLITE/LICENSE >> $RLITE_COPYING
