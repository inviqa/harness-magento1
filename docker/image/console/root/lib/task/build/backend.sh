#!/bin/bash

function task_build_backend()
{
    task "composer:install"
    task "magento:n98"
}
