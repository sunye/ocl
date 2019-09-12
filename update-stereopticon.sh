#!/bin/sh

function update_stereopticon {
    git clone https://gitlab.univ-nantes.fr/bousse-e/stereopticon.git
    cp -f stereopticon/src/css/theme/source/* reveal.js/css/theme/source/
    cp -f stereopticon/src/lib/font/* reveal.js/lib/font/
    rm -rf stereopticon
    cd reveal.js
    if test ! -d node_modules; then
        npm install
    fi
    npm run build -- css-themes
    cd ..
}

# Only call if not "sourced"
if test ${#BASH_SOURCE[@]} -eq 1 ; then
    update_stereopticon
fi
