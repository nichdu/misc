misc
====

miscellaneous scripts

## alive.rb
A skript to peridically check a file for changes. If file has not changed in the last x seconds, a Boxcar notification is thrown. The file should be changed for example by a PHP script that is called remotely.

## iban.rb
An IBAN generator from german bank account and bank identifier numbers. If the bank account number has less than 10 digits, the calculated IBAN could be incorrect.

## ibanValidator.rb
An IBAN validator. A correct IBAN does not guarantee that the bank account exists.

## new_post.sh
This script creates a new post for a jekyll blog. It takes two arguments:
```shell
new_post.sh <title> <categories>
```
```<title>``` is a title for the blog post, e.g. "Hello World"  
```<categories>``` is a comma seperated list of blog categories, e.g. "blog, misc"

It automatically adds the new blog post to your git repository and sets its published state to false.
