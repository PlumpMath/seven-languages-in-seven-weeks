# Answer

1. Evaluate `1 + 1` and then `1 + "one"`. Is Io strongly typed or weakly typed?
   Support your answer with code.

  When executing `1 + "one"` the interpreter complains that the argument to the
  method `+` must be a `Number`, so it appears to be strongly typed since it
  doesn't try to do type coercion.

2. Is `0` `true` or `false`? What about the empty string? Is `nil` `true` or
   `false`? Support your answer with code.

  `0` is `true`, empty string is `true` and `nil` is `false`.

    ```Io
    0 and true # ==> true
    "" and true # ==> true
    nil and true # ==> false
    ```

3. How can you tell what slots a prototype supports?

  You can evaluate the prototype in the REPL, which will print its local slots,
  or use the `slotNames` method on the prototype object.

4. What is the difference between `=` (equals), `:=` (colon equals), and `::=`
   (colon colon equals)? When would you use each one?

    ```
    ::= Creates slot, creates setter, assigns value
    :=  Creates slot, assigns value
    =   Assigns value to slot if it exists, otherwise raises exception
    ```

# Do

1. Run an Io program from a file.

    ```Shell
    $ cat hello_world.io
    "Hello, world!" println
    $ io hello_world.io
    Hello, world!
    ```

2. Execute the code in a slot given its name.

    ```Io
    object := Object clone
    object slot := method("Executing code in `slot`." println)
    object getSlot("slot") call
    ```
