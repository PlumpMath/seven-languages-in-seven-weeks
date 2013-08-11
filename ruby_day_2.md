# Find

1. Find out how to access files with and without code blocks. What is the
   benefit of the code block?

  With code block:

    ```Ruby
    File.open('filename.ext', 'w') { |file| file.write('some content') }
    ```

  Without code block:

    ```Ruby
    file = File.open('filename.ext', 'w')
    file.write('some content')
    file.close
    ```

  The benefit of the code block is not having to manually close the file object
  after using it. Also, arguably, not having to explicitly instantiate a file
  object.

2. How would you translate a hash to an array? Can you translate arrays to
   hashes?

  Translating a hash to an array could be done building an array of arrays
  where the inner arrays have two elements; the first being a key and the
  second being a value.

    ```Ruby
    hash = { a: 1, b: 2, c: 3 }
    hash_array = hash.zip.map(&:first)
    => [[:a, 1], [:b, 2], [:c, 3]]
    ```

  Translating arrays to hashes is done setting the array's indexes as hash
  keys.

    ```Ruby
    array = [:a, :b, :c]
    hash = array.each.with_index.inject({}) do |memo, (element, index)|
      memo[index] = element
      memo
    end
    => { 0 => :a, 1 => :b, 2 => :c  }
    ```

3. Can you iterate through a hash?

  Yes, because `Hash` mixes `Enumerable` in. Example:

    ```Ruby
    { a: 1, b: 2, c: 3 }.map { |key, value| [key, value] }
    => [[:a, 1], [:b, 2], [:c, 3]]
    ```

4. You can use ruby arrays as stacks. What other common data structures do
   arrays support?

  Lists, sets, queues and binary trees.

# Do

1. Print the contents of an array of sixteen numbers, four numbers at a time,
   using just `each`. Now, do the same with `each_slice` in `Enumerable`.

  Using just `each`:

    ```Ruby
    array = (1..16).to_a
    index = 0
    slice_size = 4
    slice_index = 0
    slices = []
    array.each do |n|
      slices[slice_index] ||= []
      slices[slice_index].push(n)
      if ((index + 1) % slice_size) == 0
        slice_index += 1
      end
      index += 1
    end
    slices.each { |slice| p slice }
    ```

  Using `Enumerator`'s `each_slice`:

    ```Ruby
    array = (1..16).to_a
    array.each_slice(4) { |slice| p slice }
    ```

2. The `Tree` class was interesting, but it did not allow you to specify a new
   tree with a clean user interface. Let the initializer accept a nested
   structure of hashes. You should be able to specify a tree like this: `{
   'grandpa' => { 'dad' => { 'child 1' => {}, 'child 2' => {} }, 'uncle' => {
   'child 3' => {}, 'child 4' => {} } } }`

    ```Ruby
    class Tree
      attr_accessor :node_name, :children

      def initialize(tree_hash)
        @node_name = tree_hash.keys.first
        @children = tree_hash.values.first.map do |name, children|
                      child_tree_hash = {}
                      child_tree_hash[name] = children
                      Tree.new(child_tree_hash)
                    end
      end
    end
    ```

3. Write a simple `grep` that will print the lines of a file having any
   occurrences of a phrase anywhere in that line. You will need to do a simple
   regular expression match and read lines from a file. (This is surprisingly
   simple in Ruby.) If you want, include line numbers.

    ```Ruby
    def grep(file_name, pattern)
      File.read(file_name).each_line.with_index do |line, index|
        puts "#{index} #{line}" if line.match(pattern)
      end
    end
    ```
