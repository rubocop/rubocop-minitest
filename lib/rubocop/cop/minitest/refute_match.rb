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
      #   refute(matcher.match?(string))
      #   refute(matcher =~ string)
      #   refute_operator(matcher, :=~, string)
      #   assert_operator(matcher, :!~, string)
      #   refute(matcher.match(string), 'message')
      #
      #   # good
      #   refute_match(matcher, string)
      #   refute_match(matcher, string, 'message')
      #
      class RefuteMatch < Base
        include ArgumentRangeHelper
        include AssertRefuteMatchHelper
        extend AutoCorrector

        MSG = 'Prefer using `refute_match(%<preferred>s)`.'
        RESTRICT_ON_SEND = %i[refute refute_operator assert_operator].freeze

        def_node_matcher :match_assertion, <<~PATTERN
          {
            (send nil? :refute (send $_ {:match :match? :=~} $_) $...)
            (send nil? :refute_operator $_ (sym :=~) $_ $...)
            (send nil? :assert_operator $_ (sym :!~) $_ $...)
          }
        PATTERN

        def on_send(node)
          check_match_assertion(node)
        end

        private

        def basic_preferred_assertion_method_name
          :refute
        end

        def preferred_assertion_method_name
          :refute_match
        end
      end
    end
  end
end
