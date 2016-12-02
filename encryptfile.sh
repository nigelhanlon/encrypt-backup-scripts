#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Usage: ./encryptfile.sh /home/app/mydump.sql /put/backups/here'
    exit 0
fi

FILETOENCRYPT=$1
DESTINATION=$2

if [ -f "$FILETOENCRYPT" ]
then

    if [ ! -d "$DESTINATION" ]; then
        echo "$DESTINATION does not exist."
        exit -1
    fi

    # Clean tmp directory
    rm ./tmp/*

    # Generate a 256bit random symmetric key
    openssl rand -base64 32 > ./tmp/key.bin

    # Encrypt the symmetric key. 
    openssl rsautl -encrypt -inkey ./keys/publickey.pem -pubin -in ./tmp/key.bin -out ./tmp/key.bin.enc

    # Encrypt the chosen file using random key
    openssl enc -aes-256-cbc -salt -in $FILETOENCRYPT -out encrypted.bin -pass file:./tmp/key.bin

    # Compress the encrypted backup + key.
    tar -cvzf $DESTINATION/backup_$(date +"%m_%d_%Y").tar.gz encrypted.bin ./tmp/key.bin.enc

    # Destroy the key files.
    shred -u ./tmp/key.bin
    shred -u ./tmp/key.bin.enc
    shred -u ./encrypted.bin

else
	echo "Error: $FILETOENCRYPT not found."
    exit -1
fi
