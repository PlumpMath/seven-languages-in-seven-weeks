# Find

1. The Scala API

  http://www.scala-lang.org/api/current/index.html

2. A comparison of Java and Scala
  - http://en.wikipedia.org/wiki/Scala_(programming_language)#Features_.28with_reference_to_Java.29
  - http://www.infoq.com/articles/java-8-vs-scala

3. A discussion of `var` versus `var`

  http://stackoverflow.com/questions/1791408/what-is-the-difference-between-a-var-and-val-definition-in-scala

# Do

1. Write a game that will take a tic-tac-toe board with X, O, and blank
   characters and detect the winner or whether there is a tie or no winner yet.
   Use classes where appropriate.

    ```Scala
    object TicTacToe {
      object Board {
        val EmptySymbol = ' '
      }

      class Board(val grid: List[List[Option[Char]]]) {
        validate

        def rows = grid

        def columns = rows.transpose

        def diagonals = {
          List(List(rows(0)(0), rows(1)(1), rows(2)(2)),
               List(rows(2)(0), rows(1)(1), rows(0)(2)))
        }

        def lines = rows ++ columns ++ diagonals

        def cells = rows.flatten

        def homovaluedLines = {
          lines.filter { line =>
            cells.flatten.distinct.exists(cell => line.forall(_ == Some(cell)))
          }
        }

        def isAllMarked = cells.forall(_.nonEmpty)

        private def validate {
          homovaluedLines match {
            case lines if lines.length > 1 => {
              println(toString)
              throw new Error("Board has multiple homovalued lines")
            }
            case _ =>
          }
        }

        override def toString = {
          rows.foldLeft("---+---+---\n") { (prefix, row) =>
            prefix + row.map { cell =>
              " " +
              (cell match {
                case Some(cell) => cell.toString
                case _ => Board.EmptySymbol
              }) +
              " "
            }.mkString("|") + "\n---+---+---\n"
          }
        }
      }

      class Player(val symbol: Char) {
        override def toString = symbol.toString
      }

      class Game(val board: Board, val players: (Player, Player)) {
        def winner = {
          board.homovaluedLines match {
            case lines if lines.length == 1 => {
              Set(players._1, players._2).find(p => Some(p.symbol) == lines.head.head)
            }
            case _ => None
          }
        }

        def loser = {
          players match {
            case (a, b) if Some(a) == winner => Some(b)
            case (a, b) if Some(b) == winner => Some(a)
            case _ => None
          }
        }

        def tie = winner.isEmpty && board.isAllMarked

        def ended = winner.nonEmpty || tie

        override def toString = {
          "TicTacToe\n" +
          board.toString +
          ((winner, loser) match {
            case (Some(_winner), Some(_loser)) => {
              _winner.symbol + " wins, " + _loser.symbol + " loses."
            }
            case _ if tie => "Tied"
            case _ => "Still in progress"
          })
        }
      }

      def main(parameters: Array[String]) = {
        var ps = (new Player('X'), new Player('O'))
        var boardWherePlayerOneWon =
          new Board(List(List(Some(ps._1.symbol), Some(ps._2.symbol), Some(ps._2.symbol)),
                         List(Some(ps._1.symbol), Some(ps._2.symbol), None),
                         List(Some(ps._1.symbol), None,               None)))
        var boardWherePlayerTwoWon =
          new Board(List(List(Some(ps._2.symbol), Some(ps._2.symbol), Some(ps._2.symbol)),
                         List(Some(ps._1.symbol), Some(ps._1.symbol), None),
                         List(Some(ps._1.symbol), None,               None)))
        var boardWithTiedGame =
          new Board(List(List(Some(ps._2.symbol), Some(ps._2.symbol), Some(ps._1.symbol)),
                         List(Some(ps._1.symbol), Some(ps._1.symbol), Some(ps._2.symbol)),
                         List(Some(ps._2.symbol), Some(ps._2.symbol), Some(ps._1.symbol))))
        var boardWithGameInProgress =
          new Board(List(List(Some(ps._1.symbol), None,               Some(ps._2.symbol)),
                         List(Some(ps._1.symbol), Some(ps._1.symbol), Some(ps._2.symbol)),
                         List(None              , None              , None              )))
        println("Game where X wins")
        println(new Game(boardWherePlayerOneWon, ps))
        println("\nGame where O wins")
        println(new Game(boardWherePlayerTwoWon, ps))
        println("\nGame where a tie occurs")
        println(new Game(boardWithTiedGame, ps))
        println("\nGame in progress")
        println(new Game(boardWithGameInProgress, ps))
      }
    }
    ```

2. Bonus problem: Let two players play tic-tac-toe.

    ```Scala
    object TicTacToe {
      object Board {
        val Symbols = ('X', 'O')
        val EmptySymbol = ' '
      }

      class Board(val grid: List[List[Option[Char]]],
                  var marks: Option[List[(Char, (Int, Int))]]) {
        validate

        def this() = {
          this(List(List(None, None, None),
                    List(None, None, None),
                    List(None, None, None)), None)
        }

        def rows = {
          marks match {
            case Some(ms) => {
              ms.foldLeft(grid) { (grid, m) =>
                grid.updated(m._2._1, grid(m._2._1).updated(m._2._2, Some(m._1)))
              }
            }
            case _ => grid
          }
        }

        def columns = rows.transpose

        def diagonals = {
          List(List(rows(0)(0), rows(1)(1), rows(2)(2)),
               List(rows(2)(0), rows(1)(1), rows(0)(2)))
        }

        def lines = rows ++ columns ++ diagonals

        def cells = rows.flatten

        def homovaluedLines = {
          lines.filter { line =>
            cells.flatten.distinct.exists(cell => line.forall(_ == Some(cell)))
          }
        }

        def mark(mark: (Char, (Int, Int))) = marks match {
          case Some(ms) => marks = Some(ms :+ mark)
          case _ => marks = Some(List(mark))
        }

        def isAllMarked = cells.forall(_.nonEmpty)

        def lastMark = marks.map(_.last)

        def lastMarkValue = lastMark.map(_._1)

        def lastMarkCoordinates = lastMark.map(_._2)

        def isMarkValid(mark: (Char, (Int, Int))) = mark match {
          case (player, (x, y)) => {
            0 <= x && x < rows.length &&
            0 <= y && y < columns.length &&
            marks.forall(ms => ms.forall(m => m._2 != (x, y)))
          }
          case _ => false
        }

        private def validate {
          homovaluedLines match {
            case lines if lines.length > 1 => {
              println(toString)
              throw new Error("Board has multiple homovalued lines")
            }
            case _ =>
          }
        }

        override def toString = {
          rows.foldLeft("---+---+---\n") { (prefix, row) =>
            prefix + row.map { cell =>
              " " +
              (cell match {
                case Some(cell) => cell.toString
                case _ => Board.EmptySymbol
              }) +
              " "
            }.mkString("|") + "\n---+---+---\n"
          }
        }
      }

      class Player(val symbol: Char) {
        override def toString = symbol.toString
      }

      class Game(val board: Board, val players: (Player, Player)) {
        def this() = {
          this(new Board, (new Player(Board.Symbols._1), new Player(Board.Symbols._2)))
        }

        def winner = {
          board.homovaluedLines match {
            case lines if lines.length == 1 => {
              Set(players._1, players._2).find(p => Some(p.symbol) == lines.head.head)
            }
            case _ => None
          }
        }

        def loser = {
          players match {
            case (a, b) if Some(a) == winner => Some(b)
            case (a, b) if Some(b) == winner => Some(a)
            case _ => None
          }
        }

        def tie = winner.isEmpty && board.isAllMarked

        def ended = winner.nonEmpty || tie

        def currentPlayer = {
          board.lastMarkValue match {
            case Some(symbol) if symbol == players._1.symbol => players._2
            case Some(symbol) if symbol == players._2.symbol => players._1
            case _ => players._1
          }
        }

        def start = {
          clearScreen

          while (!ended) {
            println("TicTacToe (press Ctrl-C to quit)")
            println(board.toString)
            print(currentPlayer.symbol)
            println("'s turn (input format is: \"%d %d\")")

            val mark = (currentPlayer.symbol, parseCoordinates(readLine("mark> ")))

            if (board.isMarkValid(mark)) {
              board.mark(mark)
              clearScreen
            } else {
              clearScreen
              println("error: invalid mark. try again.\n")
            }
          }

          println(toString)
        }

        // TODO: make it fool-proof.
        private def parseCoordinates(input: String) = {
          val coordinates = input.split("\\s+").toList.map(_.toInt)
          (coordinates(0), coordinates(1))
        }

        private def clearScreen = {
          print(27.toChar + "[2J")
          print(27.toChar + "[;H")
        }

        override def toString = {
          "TicTacToe\n" +
          board.toString +
          ((winner, loser) match {
            case (Some(_winner), Some(_loser)) => {
              _winner.symbol + " wins, " + _loser.symbol + " loses."
            }
            case _ if tie => "Tied"
            case _ => "Still in progress"
          })
        }
      }

      def main(parameters: Array[String]) = (new Game).start
    }
    ```
