import unittest, glob, os, strformat, ../coco

suite "Compiles Nim files in coverage mode":

    setup:
        var nimcache = "tests_nimcache"
        var basename = "foo"
        var filename = fmt"{basename}.nim"
        var default_cache_folder = get_cache_folder(filename, nimcache, 0)
        var base_filename = fmt"{default_cache_folder}/coco_{basename}.c"
    teardown:
        removeDir(nimcache)

    test "Get cache folder from filename":
        ## Cache folder path pattern is <nimcache>/<filename>_<increment>_cov
        check:
            get_cache_folder(filename, nimcache, 0) == fmt"{nimcache}/{filename}_0_cov"

    test "Each compiled file should have its own folder in nimcache":
        
        compile(fmt"tests/{filename}", nimcache)
        
        check:
            existsDir(default_cache_folder) == true
            existsFile(base_filename) == true
            existsFile(fmt"{base_filename}.gcno") == true
    
    test "One should be able to pass parameters to the compiler":

        compile(fmt"tests/{filename}", nimcache, options = "--hints:off")
        
        check:
            existsDir(default_cache_folder) == true
            existsFile(base_filename) == true
            existsFile(fmt"{base_filename}.gcno") == true

    test "Running a compiled file in coverage mode should generate .gdca files":
        trace(fmt"tests/{filename}")

        check:
            existsFile(fmt"{base_filename}.gcda") == true