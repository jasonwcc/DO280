#!/bin/bash

set -euo pipefail

NODE=master01

cat << EOF | oc debug node/${NODE}
chroot /host /bin/bash -xe
echo ${@} \
| xargs -r -t -n 1 crictl pull
EOF
