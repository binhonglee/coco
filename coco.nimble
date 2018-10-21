import strutils

# Package

version       = "0.0.3" 
author        = "Samuel Roy"
description   = "Code coverage with line and branch support for Nim"
license       = "MIT"
bin = @["coco"]


skipDirs = @["tests"]



# Deps

requires "nim >= 0.18.1"
requires "cligen"
requires "glob"

task coverage, "Generate code coverage report":
  echo "Generate code coverage report"
  exec "coco"

