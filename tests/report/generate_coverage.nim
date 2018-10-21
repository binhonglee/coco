import unittest, glob, os, strformat, ../../coco

suite "Generate code coverage report":

    setup:
        var fileinfo = "report.info"
        var coverage = "tests_coverage"
        var nimcache = "tests_nimcache_report"
        var basename = "foo"
        var filename = &"{basename}.nim"
        var default_cache_folder = get_cache_folder(filename, nimcache, 0)
        var base_filename = &"{default_cache_folder}/coco_{basename}.c"
    teardown:
        discard execShellCmd(&"rm -rf {fileinfo} {coverage} {nimcache}")

    test "Generate line code coverage only from test file foo.nim":

        discard coverage(target = &"tests/{filename}", nimcache = nimcache, report_source = fileinfo, report_path = coverage)
        
        check:
            execShellCmd(&"ls {coverage}") == 0
            execShellCmd(&"ls {coverage}/index-sort-b.html") == 1 # should not generate branch coverage
    
    test "Generate code coverage in branch mode only from test file foo.nim":

        discard coverage(target = &"tests/{filename}", nimcache = nimcache, report_source = fileinfo, report_path = coverage, branch = true, verbose = true, compiler = "--hints:off")
        
        check:
            execShellCmd(&"ls {coverage}/index-sort-b.html") == 0
