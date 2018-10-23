import unittest, glob, os, strformat, ../../coco

suite "Generate code coverage report":

    setup:
        const fileinfo = "report.info"
        const coverage = "tests_coverage"
        const nimcache = "tests_nimcache_report"
        const basename = "foo"
        const filename = fmt"{basename}.nim"
        const default_cache_folder = get_cache_folder(filename, nimcache, 0)
        const base_filename = fmt"{default_cache_folder}/coco_{basename}.c"
    teardown:
        removeDir(coverage)
        removeDir(nimcache)
        removeFile(fileinfo)

    test "Generate line code coverage only from test file foo.nim":

        discard coverage(target = fmt"tests/{filename}", nimcache = nimcache, report_source = fileinfo, report_path = coverage)
        
        check:
            existsDir(coverage) == true
            existsFile(fmt"{coverage}/index-sort-b.html") == false # should not generate branch coverage
    
    test "Generate code coverage in branch mode only from test file foo.nim":

        discard coverage(target = fmt"tests/{filename}", nimcache = nimcache, report_source = fileinfo, report_path = coverage, branch = true, verbose = true, compiler = "--hints:off")
        
        check:
            existsFile(fmt"{coverage}/index-sort-b.html") == true
