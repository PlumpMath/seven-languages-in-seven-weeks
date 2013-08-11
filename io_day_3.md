1. Enhance the XML program to add spaces to show the indentation structure.

    ```Io
    Builder := Object clone

    Builder tagNamesWhiteList := list("a", "div", "li", "p", "ul")
    Builder indentationString := "  "
    Builder newLined := method(string, "#{string}\n" interpolate)
    Builder openingTag := method(name, newLined("<#{name}>" interpolate))
    Builder closingTag := method(name, newLined("</#{name}>" interpolate))
    Builder indented := method(string, indentationLevel,
      "#{indentationString repeated(indentationLevel)}#{string}" interpolate
    )

    Builder forward = method(
      buildRecursively := method(tagName, tagChildren, indentationLevel,
        string := Sequence clone

        if (tagNamesWhiteList contains(tagName)) then(
          string appendSeq(indented(openingTag(tagName), indentationLevel))

          tagChildren foreach(tag,
            string appendSeq(buildRecursively(tag name, tag arguments, indentationLevel + 1))
          )

          string appendSeq(indented(closingTag(tagName), indentationLevel))
        ) else (
          string = newLined(indented(tagName, indentationLevel))
        )

         string
      )

      buildRecursively(call message name, call message arguments, 0)
    )
    ```

2. Create a list syntax that uses brackets.

    ```Io
    squareBrackets := method(call evalArgs)
    ```

3. Enhance the XML program to handle attributes: if the first argument is a map
   (use the curly brackets syntax), add attributes to the XML program. For
   example: `book({"author": "Tate"}...)` would print `<book author="Tate">`.

    ```Io
    OperatorTable addAssignOperator(":", "atPutNumber")

    Map atPutNumber := method(
      atPut(call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
            call evalArgAt(1))
    )

    curlyBrackets := method(
      call message arguments reduce(map, argument, map doMessage(argument), Map clone)
    )

    Builder := Object clone
    Builder tagNamesWhiteList := list("a", "div", "li", "p", "ul")
    Builder indentationString := "  "
    Builder newLined := method(string, "#{string}\n" interpolate)
    Builder openingTag := method(name, attributesMap,
      if (attributesMap) then (
        attributesString := attributesMap map(key, value,
          "#{key}=\"#{value}\"" interpolate
        ) join(" ")
        string := newLined("<#{name} #{attributesString}>" interpolate)
      ) else (
        string := newLined("<#{name}>" interpolate)
      )

      string
    )
    Builder closingTag := method(name, newLined("</#{name}>" interpolate))
    Builder indented := method(string, indentationLevel,
      "#{indentationString repeated(indentationLevel)}#{string}" interpolate
    )

    Builder forward = method(
      buildRecursively := method(tagName, tagChildren, indentationLevel,
        string := Sequence clone

        if (tagNamesWhiteList contains(tagName)) then (
          firstChild := doMessage(tagChildren first)
          attributesMap := if (firstChild isKindOf(Map), firstChild)
          string appendSeq(indented(openingTag(tagName, attributesMap), indentationLevel))

         tagChildren select(child, doMessage(child) isKindOf(Map) not) foreach(tag,
            string appendSeq(buildRecursively(tag name, tag arguments, indentationLevel + 1))
          )

          string appendSeq(indented(closingTag(tagName), indentationLevel))
        ) else (
          string = newLined(indented(tagName, indentationLevel))
        )

         string
      )

      buildRecursively(call message name, call message arguments, 0)
    )

    // Code using this file needs to be executed with `doString` because we mutated
    // the `OperatorTable`.
    // See http://tech.groups.yahoo.com/group/iolanguage/message/12574
    ```
