#!/bin/bash

###############################################################################
# Copyright 2014 Tjark Saul
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

# Configuration
USER="tjark"
HOST="10.1.5.1"
PATH="backup-tjark"
FILENAME="asparagin_80e65011bcb4.sparsebundle"
BUNDLE_MOUNTPOINT="/Volumes/Tjark_Backup"
KEYCHAIN_HOSTNAME="lysin._smb._tcp.local"

# It's suggested that you add the following lines to 
# your sudoers file (replace USER with your user name)
# USER ALL = (root) NOPASSWD: /sbin/mount
# USER ALL = (root) NOPASSWD: /usr/bin/hdiutil
# if you  don't know what sudoers is, read sudoers(5)

# first of all, let's check if the host is available
/sbin/ping -c1 $HOST > /dev/null
PING_RETURN=$?
if [ $PING_RETURN -ne 0 ]; then
    echo "Backup host not reachable"
    exit 5
fi
echo "Backup host is reachable. Continuing."

# let's create a mount point
MOUNTPOINT=`/usr/bin/mktemp -d -q -t backup`
MP_RET=$?
if [ $MP_RET -ne 0 ]; then
    echo "Could not create mount point"
    exit 6
fi

# we get the password from the keychain
PASSWORD=`/usr/bin/security find-internet-password -wa ${USER} -s ${KEYCHAIN_HOSTNAME}`
PW_RET=$?
if [ $PW_RET -ne 0 ]; then
    echo "Could not get password"
    exit 4
fi

# we mount the remote file system to the mount point
/usr/bin/sudo /sbin/mount -t smbfs\
 //${HOST}\;${USER}:${PASSWORD}@${HOST}/${PATH} $MOUNTPOINT
MT_RET=$?
if [ $MT_RET -ne 0 ]; then
    echo "Could not mount network path"
    exit 7
fi

# next, we mount the sparse bundle
/usr/bin/sudo /usr/bin/hdiutil attach -quiet -nobrowse -mountpoint $BUNDLE_MOUNTPOINT ${MOUNTPOINT}/${FILENAME}
HDU_RET=$?
if [ $HDU_RET -ne 0 ]; then
    echo "Could not mount sparsebundle"
    exit 7
fi

# finally, we try to start the backup
/usr/bin/tmutil startbackup --auto 
TM_RET=$?
if [ $TM_RET -ne 0 ]; then
    echo "Could not start backup"
    exit 3;
fi
echo "No errors. Backup should be running"
