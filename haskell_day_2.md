# Find

1. Functions that you can use on lists, strings, or tuples.

2. A way to sort lists.

# Do

1. Write a sort that takes a list and returns a sorted list.

```Haskell
sort' :: (Ord a) => [a] -> [a]
sort' [] = []
sort' (x:xs) = sort' (filter (< x) xs) ++ [x] ++ sort' (filter (> x) xs)
```

2. Write a sort that takes a list and a function that compares its two arguments
and then returns a sorted list.

```Haskell
sortBy' :: (Ord a) => (a -> a -> Bool) -> [a] -> [a]
sortBy' _ [] = []
sortBy' f (x:xs) = sortBy' f smaller ++ [x] ++ sortBy' f bigger
  where smaller = filter (f x) xs
        bigger  = filter (`f` x) xs
```

3. Write a Haskell function to convert a string to a number. The string should
be in the form of `$2,345,678.99` and can possibly have leading zeros.

```Haskell
currencyToFloat :: String -> Float
currencyToFloat s =
  sum $
    zipWith
      (*)
      (reverse $ map (\x -> (fromIntegral . digitToInt) x :: Float) $ filter isDigit s)
      (iterate (* 10) 0.01)
```

4. Write a function that takes an argument `x` and returns a lazy sequence that
has every third number, starting with `x`. Then, write a function that includes
every fifth number, beginning with `y`. Combine these functions through
composition to return every eighth number, beginning with `x + y`.

```Haskell
iteratePlus3 :: (Num a) => a -> [a]
iteratePlus3 = iterate (+3)

iteratePlus5 :: (Num a) => a -> [a]
iteratePlus5 = iterate (+5)

iteratePlus8 :: (Num a) => a -> a -> [a]
iteratePlus8 x y = zipWith (+) (iteratePlus3 x) (iteratePlus5 y)
```

5. Use a partially applied function to define a function that will return half
of a number and another that will append `\n` to the end of any string.

```Haskell
half :: (Fractional a) => a -> a
half = flip (/) 2
```

6. Write a function to determine the greatest common denominator of two
integers.

```Haskell
gcd' :: (Integral a) => a -> a -> a
gcd' x y = last $ divisors x `intersect` divisors y
  where divisors x = filter ((== 0) . mod x) [1 .. x `div` 2] ++ [x]
```

7. Create a lazy sequence of prime numbers.

```Haskell
primes :: [Integer]
primes = generatePrimes [2..]
  where generatePrimes (p:xs) = p:generatePrimes [x | x <- xs, x `mod` p > 0]
```

8. Break a long string into individual lines at proper word boundaries.

```Haskell
newlined :: String -> String
newlined = (++ "\n")
```

9. Add line numbers to the previous exercise.

```Haskell
numerizedNewlinedWords :: String -> String
numerizedNewlinedWords s = unlines $ zipWith (++) (map ((++ " ") . show) [1..]) (words s)
```

10. To the above exercise, add functions to left, right, and fully justify the
text with spaces (making both margins straight).

```Haskell
```
