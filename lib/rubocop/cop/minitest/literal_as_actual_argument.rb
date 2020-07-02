# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces correct order of expected and
      # actual arguments for `assert_equal`.
      #
      # @example
      #   # bad
      #   assert_equal foo, 2
      #   assert_equal foo, [1, 2]
      #   assert_equal foo, [1, 2], 'message'
      #
      #   # good
      #   assert_equal 2, foo
      #   assert_equal [1, 2], foo
      #   assert_equal [1, 2], foo, 'message'
      #
      class LiteralAsActualArgument < Cop
        MSG = 'Replace the literal with the first argument.'

        def on_send(node)
          return unless node.method?(:assert_equal)

          actual = node.arguments[1]
          range = arguments_range(node)
          add_offense(node, location: range) if actual.recursive_basic_literal?
        end

        def autocorrect(node)
          expected, actual, message = *node.arguments
          arguments = [actual.source, expected.source, message&.source].compact.join(', ')

          lambda do |corrector|
            corrector.replace(node, "assert_equal(#{arguments})")
          end
        end

        private

        def arguments_range(node)
          node.loc.begin.end.join(node.loc.end.begin)
        end
      end
    end
  end
end
