# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the test to use `assert_empty`
      # instead of using `assert_equal([], object)` or `assert_equal({}, object)`.
      #
      # NOTE: Using `assert_empty` makes it impossible to indicate that the expected value is
      # the literal `[]` or `{}`. Since this removes the ability to express the difference
      # between those literals, it is disabled by default in consideration of that drawback.
      # Since the role of replacing the originally intended `assert([], empty_list)` with
      # `assert_equal([], empty_list)` is handled by `Minitest/AssertWithExpectedArgumentTest`,
      # this cop may be removed in the future.
      #
      # @example
      #   # bad
      #   assert_equal([], object)
      #   assert_equal({}, object)
      #
      #   # good
      #   assert_empty(object)
      #
      class AssertEmptyLiteral < Base
        include ArgumentRangeHelper
        extend AutoCorrector

        MSG = 'Prefer using `assert_empty(%<arguments>s)`.'
        RESTRICT_ON_SEND = %i[assert_equal].freeze

        def_node_matcher :assert_equal_with_empty_literal, <<~PATTERN
          (send nil? :assert_equal ${hash array} $_+)
        PATTERN

        def on_send(node)
          assert_equal_with_empty_literal(node) do |literal, matchers|
            return unless literal.values.empty?

            args = matchers.map(&:source).join(', ')

            message = format(MSG, literal: literal.source, arguments: args)
            add_offense(node, message: message) do |corrector|
              object = matchers.first

              corrector.replace(node.loc.selector, 'assert_empty')
              corrector.replace(first_and_second_arguments_range(node), object.source)
            end
          end
        end
      end
    end
  end
end
