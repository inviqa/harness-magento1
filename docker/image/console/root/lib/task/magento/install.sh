#!/bin/bash

function task_magento_install()
{
    task "mysql:available"
    task "skeleton:apply"
    task "assets:dump"
}
