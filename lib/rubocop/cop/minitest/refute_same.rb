# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the use of `refute_same(expected, object)`
      # over `refute(expected.equal?(actual))`.
      #
      # NOTE: Use `refute_same` only when there is a need to compare by identity.
      #       Otherwise, use `refute_equal`.
      #
      # @example
      #   # bad
      #   refute(expected.equal?(actual))
      #
      #   # good
      #   refute_same(expected, actual)
      #
      class RefuteSame < Base
        extend MinitestCopRule

        define_rule :refute, target_method: :equal?, preferred_method: :refute_same
      end
    end
  end
end
