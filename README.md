To build website first try:

    stack exec site deploy

If that doesn't work do the following:

    git checkout develop
    stack build
    stack exec site clean
    stack exec site build
    git add .
    git commit -m "Updated website"
    git push origin develop
    git checkout master
    rsync -a --filter='P _site/' --filter='P _cache/' --filter='P .git/' --filter='P .gitignore' --delete-excluded _site/ . 
    git add .
    git commit -m "Updated website"
    git push origin master

