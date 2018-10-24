import strutils

# Package

version       = "0.0.3" 
author        = "Samuel Roy"
description   = "Code coverage with line and branch support for Nim"
license       = "MIT"

installFiles= @["coco.nim"]
bin = @["coco"]

# Deps

requires "nim >= 0.19.0"
requires "cligen"
requires "glob"

task coverage, "Generate code coverage report":
  echo "Generate code coverage report"
  exec "./coco"

