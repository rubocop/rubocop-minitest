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
        MSG = 'Prefer using `assert_empty(%<arguments>s)` over ' \
              '`assert(%<literal>s, %<arguments>s)`.'

        def_node_matcher :assert_with_empty_literal, <<~PATTERN
          (send nil? :assert ${hash array} $...)
        PATTERN

        def on_send(node)
          assert_with_empty_literal(node) do |literal, matchers|
            args = matchers.map(&:source).join(', ')

            message = format(MSG, literal: literal.source, arguments: args)
            add_offense(node, message: message)
          end
        end
      end
    end
  end
end
