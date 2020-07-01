# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `assert_empty`
      # instead of using `assert([], object)`.
      #
      # @example
      #   # bad
      #   assert([], object)
      #   assert({}, object)
      #
      #   # good
      #   assert_empty(object)
      #
      class AssertEmptyLiteral < Cop
        include ArgumentRangeHelper

        MSG = 'Prefer using `assert_empty(%<arguments>s)` over ' \
              '`assert(%<literal>s, %<arguments>s)`.'

        def_node_matcher :assert_with_empty_literal, <<~PATTERN
          (send nil? :assert ${hash array} $...)
        PATTERN

        def on_send(node)
          assert_with_empty_literal(node) do |literal, matchers|
            return unless literal.values.empty?

            args = matchers.map(&:source).join(', ')

            message = format(MSG, literal: literal.source, arguments: args)
            add_offense(node, message: message)
          end
        end

        def autocorrect(node)
          assert_with_empty_literal(node) do |_literal, matchers|
            object = matchers.first

            lambda do |corrector|
              corrector.replace(node.loc.selector, 'assert_empty')
              corrector.replace(first_and_second_arguments_range(node), object.source)
            end
          end
        end
      end
    end
  end
end
