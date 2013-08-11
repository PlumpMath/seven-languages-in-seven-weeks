1. A Fibonacci sequence starts with two 1s. Each subsequent number is the sum
   of the two numbers that came before: 1, 1, 2, 3, 5, 8, 13, 21, and so on.
   Write a program to find the nth Fibonacci number. `fib(1)` is 1, and
   `fib(4)` is 3. As a bonus, solve the problem with recursion and with loops.

    With recursion:

    ```Io
    fib := method(n,
      if (n == 1 or n == 2) then (return(1)) else (return(fib(n - 1) + fib(n - 2)))
    )
    ```

    Without recursion:

    ```Io
    fib := method(n,
      fib_1 := 1
      fib_2 := 1

      if (n == 1 or n == 2) then (
        return(fib_1)
      ) else (
        i := 3
        fib_i_minus_1 := fib_1
        fib_i_minus_2 := fib_2
        fib_i := fib_i_minus_1 + fib_i_minus_2

        while (i <= n,
          tmp := fib_i_minus_2
          fib_i_minus_2 := fib_i_minus_1 + fib_i_minus_2
          fib_i_minus_1 := tmp
          fib_i := fib_i_minus_2
          i := i + 1
        )

        return(fib_i)
      )
    )
    ```

2. How would you change `/` to return 0 if the denominator is zero?

    ```Io
    old_division := Number getSlot("/")
    Number / = method(denominator,
      if (denominator == 0) then (return(0)) else (return(old_division(denominator)))
    )
    ```

3. Write a program to add up all of the numbers in a two-dimensional array.

    ```Io
    two_d_list := list(list(1, 2, 3), list(4, 5, 6), list(7, 8, 9))
    two_d_list map(sum) sum
    ```

4. Add a slot called `myAverage` to a list hat computes the average of all the
   numbers in a list. What happens if there are no numbers in a list? (Bonus:
   Raise an Io exception if any item in the list is not a number.)

    ```Io
    myList := list(1, 2, 3)
    myList myAverage := method(
      if (detect(element, element isKindOf(Number) not)) then (
        Exception raise("List must be exclusively made of Numbers")
      ) else (
        return(sum / size)
      )
    )
    ```

5. Write a prototype for a two-dimensional list. The `dim(x, y)` method should
   allocate a list of `y` lists that are `x` elements long. `set(x, y, value)`
   should set a value, and `get(x, y)` should return that value.

    ```Io
    TwoDList := List clone

    TwoDList dim := method(x, y,
      copy(list() setSize(y) map(oneDList, list() setSize(x)))
    )

    TwoDList set := method(x, y, value,
      at(y) atPut(x, value)
      self
    )

    TwoDList get := method(x, y,
      at(y) at(x)
    )
    ```

6. Bonus: Write a transpose method so that `(new_matrix get(y, x)) == matrix
   get(x, y)` on the original list.

    ```Io
    TwoDList transpose := method(
      transposedList := list() setSize(at(0) size) map(oneDList, list() setSize(size))

      foreach(oneDIndex, oneDList,
        oneDList foreach(index, element,
          transposedList at(index) atPut(oneDIndex, element)
        )
      )

      copy(transposedList)
    )
    ```

7. Write the matrix to a file, and read a matrix from a file.

    ```Io
    matrix := TwoDList clone
    matrix dim(2, 2)
    matrix set(0, 0, "00")
    matrix set(0, 1, "01")
    matrix set(1, 0, "10")
    matrix set(1, 1, "11")
    File open("matrix.dat") write(matrix asString)
    matrix := doString(File open("matrix.dat") contents)
    ```

8. Write a program that gives you ten tries to guess a random number from
   1--100. If you would like, give a hint of "hotter" or "colder" after the
   first guess.

    ```Io
    tries := 10
    ceiling := 100
    answer := (Random value(ceiling) floor) + 1
    previousGuess := nil

    "The computer chose an integer between 1 and 100. What is it?" println
    answer println

    tries repeat(iteration,
      guess := File standardInput readLine asNumber

      if (previousGuess) then (
        if ((guess - answer) abs > (previousGuess- answer) abs) then (
          "Colder." println
        ) elseif ((guess - answer) abs < (previousGuess - answer) abs) then (
          "Hotter." println
        )
      )

      if (guess == answer, "You guessed it correctly." println; break, "Nope." println)
      if (iteration + 1 == tries, "You failed." println)

      previousGuess = guess
    )
    ```
