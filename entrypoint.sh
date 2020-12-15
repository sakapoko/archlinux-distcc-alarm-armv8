#!/bin/sh
PATH=/opt/x-tools8/aarch64-unknown-linux-gnu/bin:$PATH
distccd --log-level info --log-stderr --allow-private --daemon --verbose --no-detach --port 3632 --jobs 10

