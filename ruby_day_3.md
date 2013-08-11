1. Modify the CSV application to support an `each` method to return a `CsvRow`
   object. Use `method_missing` on that `CsvRow` to return the value for the
   column for a given heading.

  For example, for the file:

    ```
    one, two
    lions, tigers
    ```

  allow an API that works like this:

    ```Ruby
    csv = RubyCsv.new
    csv.each { |row| puts row.one }
    ```

  This should print "`lions`"

    ```Ruby
    module ActsAsCsv
      def self.included(base)
        base.extend(ClassMethods)
      end

      class CsvRow
        ROW_NAMES = [:one, :two]
        ROW_NAME_INDEX_MAPPING =
          ROW_NAMES.each.with_index.inject({}) do |memo, (name, index)|
            memo[name] = index
            memo
          end

        def initialize(row_array)
          @row_array = row_array
        end

        def method_missing(method_name_symbol, *arguments)
          if ROW_NAMES.include?(method_name_symbol)
            @row_array.send(:[], ROW_NAME_INDEX_MAPPING[method_name_symbol])
          else
            super
          end
        end
      end

      module ClassMethods
        def acts_as_csv
          include InstanceMethods
        end
      end

      module InstanceMethods
        def initialize
          @csv_contents = [['one', 'two'], ['lions', 'tigers']]
        end

        def each
          @csv_contents.each do |row_array|
            yield(CsvRow.new(row_array))
          end
        end
      end
    end

    class RubyCsv
      include ActsAsCsv

      acts_as_csv
    end
    ```
