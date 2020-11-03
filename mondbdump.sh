#!/bin/bash

# Set up necessary variables
TIME=`/bin/date +%d-%m-%Y-%T`
DEST=~/mongodbackup/$TIME

# Tar file of backup directory
TAR=$DEST/../$TIME.tar

#Create backup dir (-p to avoid warning if already exists)
/bin/mkdir -p $DEST


# Dump from mongodb host into backup directory
mongodump -u <username> -p <your password> --host <your host name>:27017 --authenticationDatabase=admin -o $DEST

# Create tar of backup directory
/bin/tar cvf $TAR -C $DEST .

# Upload tar to s3
s3cmd -r put $TAR s3://<your bucket name>/

# Remove tar file locally
/bin/rm -f $TAR

# Remove backup directory
/bin/rm -rf $DEST

# All done
echo "Backup available at https://s3.amazonaws.com/<your bucket name>/$TIME.tar"
