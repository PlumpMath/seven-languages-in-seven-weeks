# Find

1. The Haskell wiki

https://www.haskell.org/haskellwiki/Haskell

2. A Haskell online group supporting your compiler of choice

- https://www.haskell.org/haskellwiki/IRC_channel
- http://www.reddit.com/r/haskell/
- http://stackoverflow.com/questions/tagged?tagnames=haskell

# Do

1. How many different ways can you find to write `allEven`?

```Haskell
allEven1 :: (Integral a) => [a] -> [a]
allEven1 = filter even

allEven2 :: (Integral a) => [a] -> [a]
allEven2 [] = []
allEven2 (x:xs)
  | even x    = x:allEven2 xs
  | otherwise = allEven2 xs

allEven3 :: (Integral a) => [a] -> [a]
allEven3 = foldr (\x xs -> if even x then x:xs else xs) []

allEven4 :: (Integral a) => [a] -> [a]
allEven4 [] = []
allEven4 (x:xs) = if even x then x:allEven4 xs else allEven4 xs

allEven5 :: (Integral a) => [a] -> [a]
allEven5 xs = [x | x <- xs, even x]

allEven6 :: (Integral a) => [a] -> [a]
allEven6 = filter (not . odd)
```

2. Write a function that takes a list and returns the same list in reverse.

```Haskell
reverse :: [a] -> [a]
reverse = foldl (flip (:)) []
```

3. Write a function that builds two-tuples with all possible combinations of two
of the colors black, white, blue, yellow, and red. Note that you should include
only one of `(black, blue)` and `(blue, black)`

```Haskell
combinations :: (Ord a) => [a] -> [(a, a)]
combinations xs = [(x, y) | x <- xs, y <- xs, x < y]
```

4. Write a list comprehension to build a childhood multiplication table. The
table would be a list of three-tuples where the first two are integers from
1--12 and the third is the product of the first two.

```Haskell
multiplicationTable = [(x, y, x * y) | x <- [1..12], y <- [1..12]]
```

5. Solve the map-coloring problem
([Map Coloring](http://en.wikipedia.org/wiki/Four_color_theorem)) using Haskell.
