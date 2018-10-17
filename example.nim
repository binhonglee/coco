
proc fibonacci*(n: int): int =
    if n < 2:
      result = n
    else:
      result = fibonacci(n - 1) + (n - 2).fibonacci

proc sum(x, y: int): int {. noSideEffect .} =
    x + y

proc one_plus_one*(): int = 
    sum(1, 1)

proc coverage_showcase*(x, y: int): bool =
    if x == 8:
        if y == 8:
            echo "This line should be covered"
        else:
           echo "This line should not be covered"
    else:
        echo "This line should be covered"

    if y == 5:
       echo "This line should be covered"

    if y == 6:
        echo "This line should not be covered"
    else:
       echo  "This line should be covered"
    
    true


