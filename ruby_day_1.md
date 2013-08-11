# Do

1. Print the string "Hello, world."

    ```Ruby
    puts 'Hello, world.'
    ```

2. For the string "Hello, Ruby," find the index of the word "Ruby."

    ```Ruby
    puts 'Hello, Ruby'.index('Ruby')
    ```

3. Print your name ten times.

    ```Ruby
    10.times { puts 'Murilo' }
    ```

4. Print the string "This is sentence number 1," where the number 1 changes
   from 1 to 10.

    ```Ruby
    (1..10).each { |n| puts "This is sentence number #{n}" }
    ```

5. Bonus problem: If you're feeling the need for a little more, write a program
   that picks a random number. Let a player guess the number, telling the
   player whether the guess is too low or too high. (Hint: `rand(10)` will
   generate a random number from 0 to 9, and `gets` will read a string from the
   keyboard that you can translate to an integer.)

  Using recursion:

    ```Ruby
    def guesser(guess, answer)
      if guess < answer
        puts 'The number chosen by the computer is bigger'
        guesser(gets.to_i, answer)
      elsif guess > answer
        puts 'The number chosen by the computer is smaller'
        guesser(gets.to_i, answer)
      else
        puts 'You guessed it correctly.'
      end
    end

    ceiling = 10
    puts "The computer chose a non-negative integer from 0 to #{ceiling - 1}. " +
           'What is it?'

    guesser(gets.to_i, rand(ceiling))
    ```

  Using a loop:

    ```Ruby
    ceiling = 10
    answer = rand(ceiling)
    puts "The computer chose a non-negative integer from 0 to #{ceiling - 1}. " +
           'What is it?'

    begin
      guess = gets.to_i

      if guess < answer
        puts 'The number chosen by the computer is bigger'
      elsif guess > answer
        puts 'The number chosen by the computer is smaller'
      else
        puts 'You guessed it correctly.'
      end
    end while (guess != answer)
    ```
