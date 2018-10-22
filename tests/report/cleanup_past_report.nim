import unittest, os, system, strformat, ../../coco

suite "Removes past code coverage reports and data":

    setup:
        var fileinfo = "test.info"
        var nimcache = "tests_nimcache"
        var coverage = "tests_coverage"

        var basename = "foo"
        var filename = fmt"{basename}.nim"
        var default_cache_folder = get_cache_folder(filename, nimcache, 0)
        var base_filename = fmt"{default_cache_folder}/coco_{basename}.c"
    
    teardown:
        removeDir(coverage)
        removeDir(nimcache)
        removeFile(fileinfo)
    
    test "Cleanup custom locations:":
        # create custom locations
        createDir(coverage)
        createDir(nimcache)
        writeFile(fileinfo, "")

        reset_coverage(fileinfo, coverage, nimcache)
        check:
            existsDir(coverage) == false
            existsDir(nimcache) == false
            existsFile(fileinfo) == false