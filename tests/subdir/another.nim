import unittest, ../../example

suite "Test coverage":

    test "Subdir - expect one_equals_true(1) to return true ":
        check:
            one_equals_true(1) == true
