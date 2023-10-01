#!/bin/bash

find ./Modules -type f -name README.md -exec sh -c 'cat README.md > "{}"' \;