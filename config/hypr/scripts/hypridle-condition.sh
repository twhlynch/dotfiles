#!/usr/bin/env bash

pgrep -x "pi|opencode" >/dev/null && exit 1

exit 0
