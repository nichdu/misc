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

SEARCHDIR='/media/media/Bewegtbild'
USER='samba-admin'
GROUP='sambamedien'
PERMISSION_FILE='640'
PERMISSION_DIR='750'

# Zuerst ein paar Checks

if [[ ! `id -u` -eq 0 ]]; then
    echo "Dieses Skript sollte als root ausgeführt werden"
    exit 4;
fi

if [[ (! -e $SEARCHDIR) || (! -d $SEARCHDIR) ]]; then
    echo "Der angegebene Pfad existiert nicht oder ist kein Verzeichnis"
    exit 3
fi

# Kommen wir zur Arbeit, Iteration durch die Dateien im Pfad, dann setzen wir den Owner und die Permissions
files="$(find ${SEARCHDIR})"
echo "$files" | while read FILE; do
    FU=`stat -c %U "$FILE"`
    FG=`stat -c %G "$FILE"`
    if [[ (! $FU = $USER) || (! $FG = $GROUP) ]]; then
        echo "Datei mit falschen Permissions gefunden: \"$FILE\""
        chown ${USER}:${GROUP} "$FILE"
        if [[ -d $FILE ]]; then 
            chmod ${PERMISSION_DIR} "$FILE"
        else
            chmod ${PERMISSION_FILE} "$FILE"
        fi
    fi
done
