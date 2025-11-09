#!/bin/bash
cat ./config/git-sync-config.json
chmod +x ./git.sh && cp ./.netrc ~/.netrc
./git.sh