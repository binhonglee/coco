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
    # compile test files, recursive, start with folder tests/
    exec "nimble compile_for_coverage tests"
    exec "lcov --base-directory . --directory " & nimcache & " --zerocounters -q"
    # run and capture 
    exec "nimble run_for_coverage tests"
    exec "lcov --base-directory . --directory " & nimcache & " -c -o lcov.info"
    # keep only relevant coverage informations
    exec "lcov --extract lcov.info \"" & thisDir() & "*\" -o lcov.info"
    exec "lcov --remove lcov.info \"" & thisDir() & "/tests/*\" -o lcov.info"
    # generate report
    exec "genhtml -o coverage lcov.info"

  else:
    echo("  --> `tests` folder is missing. It's required in order to generate the code coverage report.")

task compile_for_coverage, "Compile tests files for code coverage":
    let target_dir = paramStr(2)
    for file in listFiles(target_dir):
        exec "nim --debugger:native --passC:--coverage --passL:--coverage c " & file
    for dir in listDirs(target_dir):
        exec "nimble compile_for_coverage " & dir

task run_for_coverage, "Run tests for code coverage":
    let target_dir = paramStr(2)
    for file in listFiles(target_dir):
        if endsWith(file, "nim") != true:
            exec "./" & file
    for dir in listDirs(target_dir):
        exec "nimble run_for_coverage " & dir