echo Uploading all files to github.com/joshbav/sysdig-labs
echo
# All files to automatically be added
git add *
git config user.name “joshbav”
git commit -m "Scripted commit $(date +%d-%b-%Y-%I:%M:%S%p)"
git push -u origin master










