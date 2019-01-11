#!/bin/bash

function task_assets_apply()
{
    SQL="SELECT IF (COUNT(*) = 0, 'no', 'yes') FROM information_schema.tables WHERE table_schema = '$DB_NAME';"
    IS_DATABASE_APPLIED="$(mysql -ss -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "$SQL")"

    if [ "$IS_DATABASE_APPLIED" = "no" ]; then

        if [ -f "/app/tools/assets/development/${DB_NAME}.sql.gz" ]; then
            run "zcat /app/tools/assets/development/${DB_NAME}.sql.gz | mysql -h $DB_HOST -u root -p$DB_ROOT_PASS $DB_NAME"
        else
            task "magento:install"
        fi

        run "bin/n98-magerun.phar index:reindex:all"
        run "bin/n98-magerun.phar sys:setup:incremental -n"

        task "magento:configure"
    fi

    for file in /app/tools/assets/development/*.files.{tgz,tar.gz}; do
        [ -f "$file" ] || continue
        run "tar -zxvf ${file} -C /app"
    done
}
