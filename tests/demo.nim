import unittest, ../example

suite "Test coverage":

    test "Fibonacci - expect result to be 1 when n = 1":
        check:
            fibonacci(1) == 1

    test "Fibonacci - expect result to be 55 when n = 10":
        check:
            fibonacci(10) == 55

    test "1 + 1 should equal 2":
        check:
            one_plus_one() == 2

    test "Simple test to showcase covered and uncovered lines in code":
        check:
            coverage_showcase(8,8) == true
            coverage_showcase(5,10) == true