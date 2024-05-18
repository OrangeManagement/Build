#!/bin/bash

MSG="$1"

git submodule foreach git add .
git submodule foreach "git commit -m \"${MSG}\" || true"
git submodule foreach git push
git add .
git commit -m "${MSG}"
git push