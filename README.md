To build website do:

    git checkout develop
    stack build
    stack exec site build
    git add .
    git commit -m "Updated website"
    git push origin develop
    cp -r _site ../
    git checkout master
    mv ../_site/* ./
    git add .
    git commit -m "Updated website"
    git push origin master

