#!/bin/sh
git remote update
git reset --hard origin/master
git fetch origin --depth=1