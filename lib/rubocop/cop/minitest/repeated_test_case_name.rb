# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop checks for repeated test case names.
      #
      # @example
      #   # bad
      #   class FooTest < Minitest::Test
      #     def test_do_something
      #       assert_equal(foo, bar)
      #     end
      #
      #     def test_do_something
      #       assert_equal(baz, quux)
      #     end
      #   end
      #
      #   # good
      #   class FooTest < Minitest::Test
      #     def test_do_something
      #       assert_equal(foo, bar)
      #     end
      #
      #     def test_do_something_when_some_condition
      #       assert_equal(baz, quux)
      #     end
      #   end
      #
      class RepeatedTestCaseName < Cop
        include MinitestExplorationHelpers

        MSG = 'Repeated test case name detected.'

        def on_class(class_node)
          return unless minitest_test_subclass?(class_node)

          seen = {}

          test_cases(class_node).each do |node|
            name = node.method_name

            if seen.key?(name)
              add_offense(node, location: :name)
            else
              seen[name] = true
            end
          end
        end
      end
    end
  end
end
