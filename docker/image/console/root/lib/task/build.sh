#!/bin/bash

function task_build()
{
    case "$1" in
        "pass-1")
            _build_pass_1
            ;;
        "pass-2")
            _build_pass_2
            ;;
    esac
}

_build_pass_1()
{
    task "skeleton:apply"
    task "composer:install"
    task "magento:n98"
}

_build_pass_2()
{
    echo "pass 2"
}
