# Find

1. For the sizer program, what would happen if you did not create a new actor
   for each link you wanted to follow? What would happen to the performance of
   the application?

  If no actors were created the networking calls would block the thread and the
  behavior would be identical to getting the page sizes sequentially. If only
  one actor was created the behavior would also be the same, with the exception
  of an additional trivial amount of time spent instantiating an actor.

# Do

1. Take the sizer application and add a message to count the number of links on
   the page.

    ```Scala
    object PageLoader {
      def loadPage(url: String) =  {
        try {
          StringEscapeUtils.unescapeHtml4(Source.fromURL(url, "iso-8859-1").mkString)
        } catch {
          case e: Exception => ""
        }
      }
    }

    object PageAnalyzer {
      val linkRegex = """<a\s+.*?href=['"]http.*?['"].*?>.*?</a>""".r

      def pageSize(content: String) = content.length

      def pageLinksCount(content: String) = {
        linkRegex.findAllIn(content).length
      }
    }

    val urls = List("http://www.amazon.com/",
                    "https://www.twitter.com/",
                    "https://www.google.com/",
                    "http://www.cnn.com/")

    def timeMethod(method: () => Unit) = {
      val start = System.nanoTime
      method()
      val end = System.nanoTime
      println("Method took " + (end - start) / 1000000000.0 + " seconds.")
    }

    def getPagesSequentially() = {
      for(url <- urls) {
        val pageContent = PageLoader.loadPage(url)
        println(url + ": " +
                "size=" + PageAnalyzer.pageSize(pageContent) + " " +
                "links count=" + PageAnalyzer.pageLinksCount(pageContent))
      }
    }

    def getPagesConcurrently() = {
      val caller = self

      for(url <- urls) {
        actor {
          val pageContent: String = PageLoader.loadPage(url)
          caller ! (url,
                    PageAnalyzer.pageSize(pageContent),
                    PageAnalyzer.pageLinksCount(pageContent))
        }
      }

      for(i <- 1 to urls.size) {
        receive {
          case (url, size, linksCount) =>
            println(url + ": " + "size=" + size + " links count=" + linksCount)
        }
      }
    }

    println("Sequential run:")
    timeMethod { getPagesSequentially }

    println("Concurrent run")
    timeMethod { getPagesConcurrently }
    ```

2. Bonus problem: Make the sizer follow the links on a given page, and load
   them as well. For example, a sizer for "google.com" would compute the size
   for Google and all of the pages it links to.

    ```Scala
    import java.net.URLDecoder
    import scala.actors._
    import Actor._
    import scala.io._
    import org.apache.commons.lang3.StringEscapeUtils

    object PageLoader {
      def loadPage(url: String) =  {
        try {
          StringEscapeUtils.unescapeHtml4(Source.fromURL(url, "iso-8859-1").mkString)
        } catch {
          case e: Exception => ""
        }
      }
    }

    object PageAnalyzer {
      val linkRegex = """<a\s+.*?href=['"](http.*?)['"].*?>.*?</a>""".r

      def pageSize(content: String) = content.length

      def pageLinks(content: String) = {
        linkRegex.findAllIn(content)
      }

      def pageLinksHrefs(content: String) = {
        pageLinks(content).matchData.map(link => link.group(1))
      }

      def pageLinksCount(content: String) = {
        pageLinks(content).length
      }

      def pageLinksSize(content: String) = {
        pageLinksHrefs(content).foldLeft(0) { (size, link) =>
          size + pageSize(PageLoader.loadPage(link))
        }
      }
    }

    val urls = List("http://www.amazon.com/",
                    "https://www.twitter.com/",
                    "https://www.google.com/",
                    "http://www.cnn.com/")

    def timeMethod(method: () => Unit) = {
      val start = System.nanoTime
      method()
      val end = System.nanoTime
      println("Method took " + (end - start) / 1000000000.0 + " seconds.")
    }

    def getPagesSequentially() = {
      for(url <- urls) {
        val pageContent = PageLoader.loadPage(url)
        println(url + ": " +
                "size=" + PageAnalyzer.pageSize(pageContent) + " " +
                "links count=" + PageAnalyzer.pageLinksCount(pageContent) + " " +
                "links size=" + PageAnalyzer.pageLinksSize(pageContent))
      }
    }

    def getPagesConcurrently() = {
      val caller = self

      for(url <- urls) {
        actor {
          val pageContent: String = PageLoader.loadPage(url)
          caller ! (url,
                    PageAnalyzer.pageSize(pageContent),
                    PageAnalyzer.pageLinksCount(pageContent),
                    PageAnalyzer.pageLinksSize(pageContent))
        }
      }

      for(i <- 1 to urls.size) {
        receive {
          case (url, size, linksCount, linksSize) =>
            println(url + ": " +
              "size=" + size + " " +
              "links count=" + linksCount + " " +
              "links size=" + linksSize)
        }
      }
    }

    println("Sequential run:")
    timeMethod { getPagesSequentially }

    println("Concurrent run")
    timeMethod { getPagesConcurrently }
    ```
