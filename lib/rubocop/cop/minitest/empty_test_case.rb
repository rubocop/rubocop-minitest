# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop checks for empty test cases.
      #
      # @example
      #   # bad
      #   class FooTest < Minitest::Test
      #     def test_do_something
      #     end
      #   end
      #
      #   # good
      #   class FooTest < Minitest::Test
      #     def test_do_something
      #       assert_equal(foo, bar)
      #     end
      #   end
      #
      class EmptyTestCase < Cop
        include MinitestExplorationHelpers

        MSG = 'Empty test case detected.'

        def on_class(class_node)
          return unless minitest_test_subclass?(class_node)

          test_cases(class_node).each do |node|
            add_offense(node) if node.body.nil?
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.remove(node)
          end
        end
      end
    end
  end
end
