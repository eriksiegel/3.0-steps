#!/bin/bash

# temporarily disable; it surely won't work.
exit

if [ "$TRAVIS_REPO_SLUG" == "$GIT_PUB_REPO" ]; then
    echo -e "Setting up for publication...\n"

    cd $HOME
    git config --global user.email ${GIT_EMAIL}
    git config --global user.name ${GIT_NAME}
    git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/${GIT_PUB_REPO} gh-pages > /dev/null

    if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
        echo -e "Publishing specification...\n"

        TIP=${TRAVIS_TAG:="head"}

        cd gh-pages
        git rm -rf ./${TRAVIS_BRANCH}/${TIP} > /dev/null
        mkdir -p ./${TRAVIS_BRANCH}/${TIP}
        cp -Rf $TRAVIS_BUILD_DIR/build/dist/* ./${TRAVIS_BRANCH}/${TIP}

        if [ "$GITHUB_CNAME" != "" ]; then
            echo $GITHUB_CNAME > CNAME
        fi

        git add --verbose -f .
        git commit -m "Successful travis build $TRAVIS_BUILD_NUMBER"
        git push -fq origin gh-pages > /dev/null

        echo -e "Published specification to gh-pages.\n"
    else
        echo -e "Publication cannot be performed on pull requests.\n"
    fi
fi
