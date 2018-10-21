import unittest, os, strformat, ../../coco

suite "Removes past code coverage reports and data":

    setup:
        var fileinfo = "test.info"
        var nimcache = "tests_nimcache"
        var coverage = "tests_coverage"

        var basename = "foo"
        var filename = &"{basename}.nim"
        var default_cache_folder = get_cache_folder(filename, nimcache, 0)
        var base_filename = &"{default_cache_folder}/coco_{basename}.c"
    
    teardown:
        discard execShellCmd(&"rm -rf {fileinfo} {coverage} {nimcache}")
    
    test "Cleanup custom locations:":
        # create custom locations
        discard execShellCmd(&"mkdir {coverage} {nimcache}")
        discard execShellCmd(&"touch {fileinfo}")

        reset_coverage(fileinfo, coverage, nimcache)
        check:
            execShellCmd(&"ls {fileinfo}") == 1
            execShellCmd(&"ls {coverage}") == 1
            execShellCmd(&"ls {nimcache}") == 1