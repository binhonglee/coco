import unittest, glob, os, strformat, ../coco

suite "Compiles Nim files in coverage mode":

    setup:
        var nimcache = "tests_nimcache"
        var basename = "foo"
        var filename = &"{basename}.nim"
        var default_cache_folder = get_cache_folder(filename, nimcache, 0)
        var base_filename = &"{default_cache_folder}/coco_{basename}.c"
    teardown:
        discard execShellCmd(&"rm -rf {nimcache}")

    test "Get cache folder from filename":
        ## Cache folder path pattern is <nimcache>/<filename>_<increment>_cov
        check:
            get_cache_folder(filename, nimcache, 0) == &"{nimcache}/{filename}_0_cov"

    test "Each compiled file should have its own folder in nimcache":
        
        compile(&"tests/{filename}", nimcache)
        
        check:
            execShellCmd(&"ls {default_cache_folder}") == 0
            execShellCmd(&"ls {base_filename}") == 0
            execShellCmd(&"ls {base_filename}.gcno") == 0
    
    test "One should be able to pass parameters to the compiler":

        compile(&"tests/{filename}", nimcache, options = "--hints:off")
        
        check:
            execShellCmd(&"ls {default_cache_folder}") == 0
            execShellCmd(&"ls {base_filename}") == 0
            execShellCmd(&"ls {base_filename}.gcno") == 0

    test "Running a compiled file in coverage mode should generate .gdca files":
        trace(&"tests/{filename}")

        check:
            execShellCmd(&"ls {base_filename}.gcda") == 0