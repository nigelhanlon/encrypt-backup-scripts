#!/bin/bash

FILETODECRYPT=$1
KEYFILE=$2
PRIVATEKEY=$3
DESTINATION=$4

if [[ $# -eq 0 ]] ; then
    echo 'Usage: ./decryptfile.sh encrypted.bin key.bin.enc privatekey.pem'
    echo 'encrypted.bin - The encrypted backup file from the backup tar.gz'
    echo 'key.bin.enc - The encryption key from the backup tar.gz'
    echo 'privatekey.pem - The private key file for this project.'
    exit 0
fi

if [ ! -f "$FILETODECRYPT" ]
then
	echo "$FILETODECRYPT (file to decrypt) not found."
    exit -1
fi

if [ ! -f "$KEYFILE" ]
then
	echo "$KEYFILE (encryption key) not found."
    exit -1
fi

if [ ! -f "$PRIVATEKEY" ]
then
	echo "$PRIVATEKEY (private key) not found."
    exit -1
fi

if [ ! -d "$DESTINATION" ]; then
    echo "$DESTINATION (output) does not exist."
    exit -1
fi

# Decrypt the symetric key for this backup.
openssl rsautl -decrypt -inkey $PRIVATEKEY -in $KEYFILE -out ./tmp/key.bin 

# Decrypt the backup using the cleartext key.
openssl enc -d -aes-256-cbc -in $FILETODECRYPT -out $DESTINATION/file.bin -pass file:./tmp/key.bin

# Destroy clear text key.
shred -u ./tmp/key.bin