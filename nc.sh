#!/bin/sh

cd $(dirname $0);

#会在终端显示当前路径
pwd -P

git status
git add .
git rm --cached com.fuhope.sale/Pods/AMap3DMap/MAMapKit.framework/MAMapKit
git commit -m "normal commit"
git pull -r
git push origin master

open .

# mkdir shell_tut
#   for ((i=0; i<10; i++)); do
#   touch test_$i.txt
#   done
