# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `refute_match`
      # instead of using `refute(matcher.match(string))`.
      #
      # @example
      #   # bad
      #   refute(matcher.match(string))
      #   refute(matcher.match(string), 'the message')
      #
      #   # good
      #   refute_match(matcher, string)
      #   refute_match(matcher, string, 'the message')
      #
      class RefuteMatch < Cop
        extend MinitestCopRule

        rule :refute, target_method: :match, prefer_method: :refute_match
      end
    end
  end
end
