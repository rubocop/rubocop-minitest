# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Checks if test cases contain too many assertion calls. If conditional code with assertions
      # is used, the branch with maximum assertions is counted.
      # The maximum allowed assertion calls is configurable.
      #
      # @example Max: 1
      #   # bad
      #   class FooTest < Minitest::Test
      #     def test_asserts_twice
      #       assert_equal(42, do_something)
      #       assert_empty(array)
      #     end
      #   end
      #
      #   # good
      #   class FooTest < Minitest::Test
      #     def test_asserts_once
      #       assert_equal(42, do_something)
      #     end
      #
      #     def test_another_asserts_once
      #       assert_empty(array)
      #     end
      #   end
      #
      class MultipleAssertions < Base
        include ConfigurableMax
        include MinitestExplorationHelpers

        MSG = 'Test case has too many assertions [%<total>d/%<max>d].'

        def on_class(class_node)
          return unless test_class?(class_node)

          test_cases(class_node).each do |node|
            assertions_count = assertions_count(node.body)

            next unless assertions_count > max_assertions

            self.max = assertions_count

            message = format(MSG, total: assertions_count, max: max_assertions)
            add_offense(node, message: message)
          end
        end

        private

        def assertions_count(node)
          return 0 unless node.is_a?(RuboCop::AST::Node)

          assertions =
            case node.type
            when :if, :case, :case_match
              assertions_count_in_branches(node.branches)
            when :rescue
              assertions_count(node.body) + assertions_count_in_branches(node.branches)
            when :block, :numblock
              assertions_count(node.body)
            else
              node.each_child_node.sum { |child| assertions_count(child) }
            end

          assertions += 1 if assertion_method?(node)
          assertions
        end

        def assertions_count_in_branches(branches)
          branches.map { |branch| assertions_count(branch) }.max
        end

        def max_assertions
          Integer(cop_config.fetch('Max', 3))
        end
      end
    end
  end
end
