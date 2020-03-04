# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `assert_match`
      # instead of using `assert(matcher.match(string))`.
      #
      # @example
      #   # bad
      #   assert(matcher.match(string))
      #   assert(matcher.match(string), 'the message')
      #
      #   # good
      #   assert_match(regex, string)
      #   assert_match(matcher, string, 'the message')
      #
      class AssertMatch < Cop
        extend MinitestCopRule

        rule :assert, target_method: :match, preferred_method: :assert_match
      end
    end
  end
end
