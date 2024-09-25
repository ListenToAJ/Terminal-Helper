#!/bin/zsh

echo "\033[38;2;255;143;252m\033[1mSetup git repo in current directory?\033[0m"
read "choice?" 
case "$choice" in 
  y|Y ) git init; touch .gitignore; touch README.md; git add .; git commit -m "Initial commit"; 
        echo "\033[38;2;5;255;193m\033[1m Remaining steps:\n\t\033[38;2;0;201;200m1) git remote add origin <url>\n\t\033[38;2;0;148;183m2) git push origin main"; 
        echo "git remote add origin " | tr -d '\n' | pbcopy ;;
  n|N ) echo "\033[38;2;255;143;252m\033[1m \nExiting!"; return;;
  * ) echo "invalid";;
esac