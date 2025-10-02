#!/bin/bash
cd "$(dirname "$0")"
git add .
git commit -m "Auto commit: $(date)"
git pull --rebase
git push
