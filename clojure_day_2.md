# Find

1. The implementation of some of the commonly used macros in the Clojure
   language

  https://github.com/clojure/clojure/blob/master/src/clj/clojure/core.clj

2. An example of defining your own lazy sequence

  - http://clojure.org/lazy
  - http://clojuredocs.org/clojure_core/clojure.core/lazy-seq

3. The current status of the `defrecord` and `protocol` features (these features
   were still under development as this book was being developed)

  http://clojure.org/datatypes

# Do

1. Implement an `unless` with an `else` condition using macros.

    ```Clojure
    (defmacro unless [test-expr then-expr & [else-expr]]
      (if test-expr else-expr then-expr))
    ```

2. Write a type using `defrecord` that implements a protocol.

    ```Clojure
    (defprotocol Attacker
      (attack [this attackee]))

    (defrecord WhiteWolf [name] Attacker
      (attack [this attackee] (println (str name " bites " (:name attackee)))))

    (defrecord Wingbat [name] Attacker
      (attack [this attackee] (println (str name " screeches at " (:name attackee)))))

    (let [wingbat (Wingbat. "Flurbles")
          white-wolf (WhiteWolf. "Growlster")]
      (attack wingbat white-wolf)
      (attack white-wolf wingbat))
    ```
