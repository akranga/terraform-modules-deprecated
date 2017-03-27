#!/bin/bash -e

rand=$(cat /dev/urandom | env LC_CTYPE=C tr -cd 'a-f0-9' | head -c 32)


eval "$(jq -r '@sh "YAML=\(.yaml) PLATFORM=\(.platform)"')"
cat <<EOF | ct -platform "${PLATFORM}" -pretty | jq -c -M . > .terraform/${rand}.tmp
${YAML}
EOF

RESULT=$(cat .terraform/${rand}.tmp)

jq -n --arg result "${RESULT}" '{"rendered":$result}'
