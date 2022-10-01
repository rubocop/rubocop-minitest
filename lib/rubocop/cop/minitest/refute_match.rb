# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the test to use `refute_match`
      # instead of using `refute(matcher.match(string))`.
      #
      # @example
      #   # bad
      #   refute(matcher.match(string))
      #   refute(matcher.match(string), 'message')
      #
      #   # good
      #   refute_match(matcher, string)
      #   refute_match(matcher, string, 'message')
      #
      class RefuteMatch < Base
        extend MinitestCopRule

        define_rule :refute, target_method: :match, inverse: 'regexp_type?'
      end
    end
  end
end
