# Find

1. A discussion on how to use Scala files

  Not sure if "Scala files" means
  [Scala file IO operations](http://www.javacodegeeks.com/2011/10/scala-tutorial-scalaiosource-accessing.html)
  or [literal Scala files](http://www.scala-lang.org/old/node/166).

2. What makes a closure different from a code block

  http://downgra.de/2010/08/05/scala_gotcha_blocks_and_functions/

# Do

1. Use `foldLeft` to compute the total size of a list of strings.

    ```Scala
    List("foo", "bar", "baz").foldLeft(0)(_ + _.size)
    ```

2. Write a `Censor` trait with a method that will replace the curse words
   **Shoot** and **Darn** with **Pucky** and **Beans** alternatives. Use a map
   to store the curse words and their alternatives.

    ```Scala
    trait Censor {
      val curseWordAlternatives = Map("Shoot" -> "Pucky", "Darn" -> "Beans")

      def censor(string: String) = {
        string.split(' ').map { word =>
          curseWordAlternatives.get(word).getOrElse(word)
        }.mkString(" ")
      }
    }
    ```

3. Load the curse words and alternatives from a file.

    ```Bash
    $ cat curse_word_alternatives.dat
    Shoot Pucky
    Darn  Beans
    ```

    ```Scala
    trait Censor {
      val curseWordAlternatives = parseCurseWordAlternatives("curse_word_alternatives.dat")

      def censor(string: String) = {
        string.split(' ').map { word =>
          curseWordAlternatives.get(word).getOrElse(word)
        }.mkString(" ")
      }

      private def parseCurseWordAlternatives(filePath: String) = {
        io.Source.fromFile(filePath).getLines.toList.map { line =>
          val Array(curseWord, alternative) = line.split("\\s+")
          Map(curseWord -> alternative)
        }.reduce(_ ++ _)
      }
    }
    ```
