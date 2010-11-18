#!/bin/sh

CFG_SCRIPT="../../scripts/rbh-config"

service mysqld start

$CFG_SCRIPT create_db robinhood_lustre localhost robinhood
$CFG_SCRIPT empty_db robinhood_lustre

LOOP_FILE=/tmp/rbh.loop.cont
MNT_PT=/tmp/mnt.rbh

echo "Checking test filesystem..."

if [[ ! -d $MNT_PT ]]; then
    echo "creating $MNT_PT"
    mkdir $MNT_PT || exit 1
fi

if [[ ! -s $LOOP_FILE ]]; then
    echo "creating file container $LOOP_FILE..."
    dd if=/dev/zero of=$LOOP_FILE bs=1M count=400 || exit 1
    echo "formatting as ext3..."
    mkfs.ext3 -F $LOOP_FILE || exit 1
fi
    
# mount it!
mnted=`mount | grep $MNT_PT | grep loop | wc -l`
if (( $mnted == 0 )); then
    mount -o loop -t ext3 $LOOP_FILE $MNT_PT || exit 1
fi

df $MNT_PT
