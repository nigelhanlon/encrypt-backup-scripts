Backup Encryption Scripts
=========================

These scripts can be used to encrypt and decrypt backup files using public/private key encryption.

Basic Usage:

[ 1. Generate a Public/Private Key Pair ]

./generatekeys.sh
Generating RSA private key, 2048 bit long modulus
........................................................................+++
.................................................+++
e is 65537 (0x10001)
writing RSA key



[ 2. Keep the Private Key Secure ] 

ls keys/
privatekey.pem  publickey.pem 

The privatekey.pem file should be removed to a secure location.


[ 3. Encrypt a backup ]

./encryptfile.sh my_database_dump.sql /mnt/backups

This script will encrypt the file given as the first argument and place the encrypted version in the destination path.


[ 4. Decrypt a backup ] 

Take an encrypted archive and extract it. 
Two files should be present, key.bin.enc and encrypted.bin.

encrypted.bin is the encrypted backup file.
key.bin.enc is the encrypted version of the symmetric key.
privatekey.pem is the private key file that was genertated for this project.

./decryptfile.sh encrypted.bin key.bin.enc privatekey.pem backup/

If decryption is successful, you will see a new file (file.bin) placed in the destination folder.

If you are unsure of the file type, use the file command to identify it:

file backup/file.bin 
backup/file.bin: JPEG image data



Technical Specification
=======================

The backup is secured using a combination of Public/Private Key RSA encryption and AES256 in Cipher Block Chaining mode.

A 2048-bit key pair is generated for a given project.
- The private key file should be stored in a secure location.
- The public key file should be present on all servers that will be encrypting backups.

To encrypt a backup file, the follow operations are preformed:

- A 256 bit cryptography secure random symmetric key is generated.
- The symmetric key is used to encrypt the backup file using AES256-CBC.
- The RSA Public Key encrypts the symmetric key.
- The encrypted backup file and encrypted symmetric key are compressed into a backup archive.
- The plain text version of the symmetric key is then securly deleted.

To decrypt a backup file:

- Decryption requireds the private key, encrypted backup file and the matching encrypted symmetric key.
- The private key file is used to RSA Decrypt the encrypted symmetric key.
- The plain text symmetric key is used to decrypted the AES256-CBC encrypted backup file.
- The plain text symmetric key is securely deleted.


Important notes:

1. If the private key is lost, all backups are irrecoverable.
2. Each backup archive has a unique matching symmetric key. 
3. A symmetric key from another archive cannot be used and if the matching key is lost, that archive is irrecoverable.

