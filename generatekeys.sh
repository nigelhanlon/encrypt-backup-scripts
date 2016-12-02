#!/bin/bash
echo "This will DESTROY ALL EXISTING KEYS in ./keys and generate new ones."
read -p "Press ENTER to continue or CTRL-C to exit"

# Generate an RSA public/private keypair
openssl genrsa -out ./keys/privatekey.pem 2048
openssl rsa -in ./keys/privatekey.pem -pubout -outform pem > ./keys/publickey.pem
