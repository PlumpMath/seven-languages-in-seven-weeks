# Find

1. Examples using Clojure sequences

  http://clojure.org/sequences

2. The formal definition of a Clojure function

  http://clojure.org/special_forms#fn

3. A script for quickly invoking the repl in your environment

  [Leiningen](http://leiningen.org/) allows repl invocation with `$ lein repl`.

# Do

1. Implement a function called `(big st n)` that returns true if a string `st`
   is longer than `n` characters.

    ```Clojure
    (defn big [string n] (> (count string) n))
    ```

2. Write a function called `(collection-type coll)` that returns `:list`, `:map`,
   or `:vector` based on the type of collection `coll`.

    ```Clojure
    (defn collection-type
      "Returns the collection type of coll. Can be either :list, :map or :vector."
      [coll]
      ({clojure.lang.PersistentList     :list
        clojure.lang.PersistentArrayMap :map
        clojure.lang.PersistentVector   :vector} (type coll)))
    ```
