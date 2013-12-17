#!/bin/sh

cd _posts/
DATE=`date +%Y-%m-%d`
DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
TITLE=$1
TITLENAME=`echo $TITLE | awk '{print tolower($0)}' | sed 'y/aáaàäeéeèiíiìoóoòöuúuùüAÁAÀEÉEÈIÍIÌOÓOÒUÚUÙÜß/aaaaaeeeeiiiiooooouuuuuAAAAEEEEIIIIOOOOUUUUUs/' | sed -e 's/[[:space:]]/-/g'`
FILE=$DATE-$TITLENAME.markdown
touch $FILE
CONTENT="
---
layout: post
title:  \"$TITLE\"
date:   $DATETIME
categories: $2
---
"
echo "---" > $FILE
echo "layout: post" >> $FILE
echo "title: \"$TITLE\"" >> $FILE
echo "date: $DATETIME" >> $FILE
echo "categories: $2" >> $FILE
echo "published: false" >> $FILE
echo "---" >> $FILE

git add $FILE

echo "Done."