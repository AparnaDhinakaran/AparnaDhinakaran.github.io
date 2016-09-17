To build website:

    git checkout develop
    *make changes*
    git add .
    git commit -m "COMMIT MESSAGE"
    git push origin develop
    stack build
    stack exec site deploy
