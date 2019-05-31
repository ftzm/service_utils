#!/usr/bin/env bash

# H;1h;$!d;x; makes sed read all lines at once.
git --no-pager log --format=%B -n 1 \
    | sed -rn 'H;1h;$!d;x; s/.*release:\s?(patch|minor|major).*/\1/p'
