#!/bin/bash

dnf repoquery --qf '%{name}\n' --userinstalled \
 | grep -v -- '-debuginfo$' \
 | grep -v '\(^kernel\)\|\(asahi\)' > dnf.txt
