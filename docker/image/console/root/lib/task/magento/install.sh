#!/bin/bash

function task_magento_install()
{
    task "mysql:available"

    # the magento installer will not work if the deployment config is present so we remove and
    # restore it after installation.

    rm -f /app/public/app/etc/local.xml

    passthru "php public/install.php -- \
        --license_agreement_accepted 'yes' \
        --locale 'en_GB' \
        --timezone 'Europe/London' \
        --default_currency 'GBP' \
        --db_model 'mysql4' \
        --db_host '${DB_HOST}' \
        --db_name '${DB_NAME}' \
        --db_user '${DB_USER}' \
        --db_pass '${DB_PASS}' \
        --url 'https://${APP_HOST}/' \
        --skip_url_validation 'yes' \
        --use_rewrites 'yes' \
        --use_secure 'yes' \
        --secure_base_url 'https://${APP_HOST}/' \
        --use_secure_admin 'yes' \
        --admin_firstname 'First' \
        --admin_lastname 'Last' \
        --admin_email 'admin@example.com' \
        --admin_username 'admin' \
        --admin_password 'admin123' \
        --encryption_key '${MAGENTO_CRYPT_KEY}' \
        --session_save 'db' \
        --admin_frontname 'admin' \
        "

    rm -f /app/public/app/etc/local.xml

    task "overlay:apply"
    task "assets:dump"
}
