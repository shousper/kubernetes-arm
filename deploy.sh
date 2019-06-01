#!/usr/bin/env bash
set -e

for pkg in $(ls)
do
    [[ ! -d ${pkg} ]] && continue
    printf "Deploying ${pkg}.. "

    (
        cd ${pkg}
        if [[ -f deploy ]]
        then
            ./deploy
        else
            kubectl apply -f .
        fi
    )
    printf "✅"
done