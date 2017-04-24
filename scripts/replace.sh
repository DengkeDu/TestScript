#!/bin/bash

# When doing the LSB tests, I need to replace the targetarch to comply for my arch.
sed -i -e 's/targetarch/x86-64/g' $1
