#!/bin/bash

function task_magento_refresh()
{
    run "bin/n98-magerun.phar cache:clean"
}
