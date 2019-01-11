#!/bin/bash

set -e

#
# Call like so, for non-standard locations:
# CODEBASE_DIRECTORY="/path/to/installation/" php composer.phar install
#
if [ -z "$CODEBASE_DIRECTORY" ]; then
    CODEBASE_DIRECTORY='./'
fi
if [ -z "$INSTALLATION_STRATEGY" ]; then
    INSTALLATION_STRATEGY='symlink'
fi

if [ "$INSTALLATION_STRATEGY" == "copy" ]; then
    echo "Using installation strategy 'copy'"
else
    echo "Using installation strategy 'symlink'"
fi

TARGET_INSTALLATION_DIRECTORY="$(pwd)/public"

symlink() {
    local parent_directory="${1%/*}"
    local target_subdirectory="$1"
    local source_location="$2"

    if [ "$parent_directory" == "$target_subdirectory" ]; then
        parent_directory="."
    fi

    echo "$TARGET_INSTALLATION_DIRECTORY/$target_subdirectory"
    if [ ! -e "$TARGET_INSTALLATION_DIRECTORY/$target_subdirectory" ]; then
        mkdir -p "$TARGET_INSTALLATION_DIRECTORY/$parent_directory"
        (cd "$TARGET_INSTALLATION_DIRECTORY/$parent_directory" && ln -s "$source_location/src/$target_subdirectory" . )
    fi
}

copy() {
    local parent_directory="${1%/*}"
    local target_subdirectory="$1"

    if [ "$parent_directory" == "$target_subdirectory" ]; then
        parent_directory="."
    fi

    echo "$TARGET_INSTALLATION_DIRECTORY/$target_subdirectory"
    if [ ! -e "$TARGET_INSTALLATION_DIRECTORY/$target_subdirectory" ]; then
        mkdir -p "$TARGET_INSTALLATION_DIRECTORY/$parent_directory"
        (cd "$TARGET_INSTALLATION_DIRECTORY/$parent_directory" && rsync -a "$CODEBASE_DIRECTORY/src/$target_subdirectory" "." )
    fi
}

install_file() {
    if [ "$INSTALLATION_STRATEGY" == "copy" ]; then
        copy "$@"
    else
        symlink "$@"
    fi
}

if [ ! -d "$CODEBASE_DIRECTORY/src/" ]; then
    echo "ERROR: No codebase located at '$CODEBASE_DIRECTORY/src/'"
    exit 1
fi

pushd "$CODEBASE_DIRECTORY/src/" || exit 1

#link modules present under app/code
find "app/code" -mindepth 3 -maxdepth 3 -type d -print0 | while read -d '' -r file; do
    install_file "$file" "../../../../.."
done

#add new modules config files under app/etc
find "app/etc/modules" -maxdepth 1 -type f -print0 | while read -d '' -r file; do
    install_file "$file" "../../../.."
done

#link theme files
find "app/design" -mindepth 2 -maxdepth 2 -type d -print0 | while read -d '' -r file; do
    install_file "$file" "../../../.."
done

#link skin files
find "skin" -mindepth 2 -maxdepth 2 -type d -print0 | while read -d '' -r file; do
    install_file "$file" "../../.."
done

#link js files
find "js" -mindepth 1 -maxdepth 1 -print0 | while read -d '' -r file; do
    install_file "$file" "../.."
done

#link shell files
find "shell" -mindepth 1 -maxdepth 1 -print0 | while read -d '' -r file; do
    install_file "$file" "../.."
done

#link errors files
find "errors" -mindepth 1 -maxdepth 1 -print0 | while read -d '' -r file; do
    install_file "$file" "../.."
done

#link other root files
find "." -mindepth 1 -maxdepth 1 ! -name "app" ! -name "js" ! -name "shell" ! -name "skin" ! -name "errors" -print0 | while read -d '' -r file; do
    install_file "${file##*/}" ".."
done

popd || exit 1
