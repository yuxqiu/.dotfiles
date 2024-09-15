#!/bin/bash

dnf repoquery --qf '%{name}' --userinstalled \
 | grep -v -- '-debuginfo$' \
 | grep -v '\(^kernel\)\|\(asahi\)' > dnf.txt
