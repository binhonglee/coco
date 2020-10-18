import unittest, glob, os, strformat, ../coco

suite "Compiles Nim files in coverage mode":

    setup:
        const nimcache = "tests_nimcache"
        const basename = "foo"
        const filename = fmt"{basename}.nim"
        const default_cache_folder = get_cache_folder(filename, nimcache, 0)
        const base_filename = fmt"{default_cache_folder}/@m{filename}.c"
    teardown:
        removeDir(nimcache)

    test "Get cache folder from filename":
        ## Cache folder path pattern is <nimcache>/<filename>_<increment>_cov
        check:
            get_cache_folder(filename, nimcache, 0) == fmt"{nimcache}/{filename}_0_cov"

    test "Each compiled file should have its own folder in nimcache":
        
        compile(fmt"tests/{filename}", nimcache)

        check:
            existsDir(default_cache_folder)
            existsFile(base_filename)
            existsFile(fmt"{base_filename}.gcno")
    
    test "One should be able to pass parameters to the compiler":

        compile(fmt"tests/{filename}", nimcache, options = "--hints:off")
        
        check:
            existsDir(default_cache_folder)
            existsFile(base_filename)
            existsFile(fmt"{base_filename}.gcno")

    test "Running a compiled file in coverage mode should generate .gdca files":
        trace(fmt"tests/{filename}")

        check:
            existsFile(fmt"{base_filename}.gcda")