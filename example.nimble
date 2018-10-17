import strutils

# Package

version       = "0.0.1" 
author        = "Samuel Roy"
description   = "Code coverage demo for Nim"
license       = "MIT"

skipDirs = @["tests"]

# Deps

requires "nim >= 0.18.1"

task coverage, "Generate code coverage report":
  echo "Generate code coverage report"
  if dirExists("tests"):
    var nimcache = nimcacheDir()
    removeSuffix(nimcache,"_d") # numcacheDir() adds _d to the path, why?
    # remove past code coverage report
    exec "rm -rf *.info coverage " & nimcache
    # compile test files
    for file in listFiles("tests"):
      exec "echo compile " & file
      exec "nim --debugger:native --passC:--coverage --passL:--coverage c " & file
    exec "lcov --base-directory . --directory " & nimcache & " --zerocounters -q"
    # run and capture 
    for file in listFiles("tests"):
      if endsWith(file, "nim") != true:
        echo "running.. " & file  
        exec "./" & file
    exec "lcov --base-directory . --directory " & nimcache & " -c -o lcov.info"
    # keep only relevant coverage informations
    exec "lcov --extract lcov.info \"" & thisDir() & "*\" -o lcov.info"
    exec "lcov --remove lcov.info \"" & thisDir() & "/tests/*\" -o lcov.info"
    # generate report
    exec "genhtml -o coverage lcov.info"

  else:
    echo("  --> `tests` folder is missing. It's required in order to generate the code coverage report.")
