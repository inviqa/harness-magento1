#!/bin/bash

function task_skeleton_apply()
{
    if [ -f /home/build/skeleton/composer-5.6.json ]; then
        if [ "${PHP_VERSION:0:3}" == "5.6" ]; then
            mv /home/build/skeleton/composer-5.6.json /home/build/skeleton/composer.json
        else
            rm -f /home/build/skeleton/composer-5.6.json
        fi
    fi
    run "rsync --exclude='*.twig' --ignore-existing -a /home/build/skeleton/ /app/"
}
