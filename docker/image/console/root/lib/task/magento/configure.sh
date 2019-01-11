#!/bin/bash

function task_magento_configure()
{
    run "bin/n98-magerun.phar config:set \"web/unsecure/base_url\"       \"https://${APP_HOST}/\""
    run "bin/n98-magerun.phar config:set \"web/secure/base_url\"         \"https://${APP_HOST}/\""
}
