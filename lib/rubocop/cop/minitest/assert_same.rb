# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the use of `assert_same(expected, actual)`
      # over `assert(expected.equal?(actual))`.
      #
      # NOTE: Use `assert_same` only when there is a need to compare by identity.
      #       Otherwise, use `assert_equal`.
      #
      # @example
      #   # bad
      #   assert(expected.equal?(actual))
      #
      #   # good
      #   assert_same(expected, actual)
      #
      class AssertSame < Base
        extend MinitestCopRule

        define_rule :assert, target_method: :equal?, preferred_method: :assert_same
      end
    end
  end
end
