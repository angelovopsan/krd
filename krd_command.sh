#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2018
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o pipefail

# shellcheck source=_functions.sh
source _functions.sh

if ! sudo -n "true"; then
    echo ""
    echo "passwordless sudo is needed for '$(id -nu)' user."
    echo "Please fix your /etc/sudoers file. You likely want an"
    echo "entry like the following one..."
    echo ""
    echo "$(id -nu) ALL=(ALL) NOPASSWD: ALL"
    exit 1
fi

valid_options=$(find . -maxdepth 1 -name "_*.sh" -exec grep -o "^function [a-z].*" {} + | awk '{printf "%s|", $2}')
function usage {
    cat <<EOF
Usage: $0 [-a <${valid_options%?}>]
EOF
}

while getopts ":a:" OPTION; do
    case $OPTION in
        a)
        eval "case \$OPTARG in
            ${valid_options%?})
            echo \"Running \$OPTARG...\"
            \$OPTARG
            ;;
            *)
            echo Invalid action
            usage
            exit 1
        esac"
        ;;
        *)
        usage
        ;;
    esac
done
