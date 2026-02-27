# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the test to use `assert_match`
      # instead of using `assert(matcher.match(string))`.
      #
      # @example
      #   # bad
      #   assert(matcher.match(string))
      #   assert(matcher.match?(string))
      #   assert(matcher =~ string)
      #   assert_operator(matcher, :=~, string)
      #   assert(matcher.match(string), 'message')
      #
      #   # good
      #   assert_match(regex, string)
      #   assert_match(matcher, string, 'message')
      #
      # @example OnlyRegexpLiteral: false (default)
      #   # bad
      #   assert /.../.match?(object)
      #   assert object.match?(/.../)
      #   assert matcher.match?(object)
      #
      #   # good
      #   assert_match(/.../, object)
      #   assert_match(matcher, object)
      #
      # @example OnlyRegexpLiteral: true
      #   # bad
      #   assert /.../.match?(object)
      #   assert object.match?(/.../)
      #
      #   # good
      #   assert_match(/.../, object)
      #   assert_match(matcher, object)
      #
      class AssertMatch < Base
        include ArgumentRangeHelper
        include AssertRefuteMatchHelper
        extend AutoCorrector

        MSG = 'Prefer using `assert_match(%<preferred>s)`.'
        RESTRICT_ON_SEND = %i[assert assert_operator].freeze

        def_node_matcher :match_assertion, <<~PATTERN
          {
            (send nil? :assert (send $_ {:match :match? :=~} $_) $...)
            (send nil? :assert_operator $_ (sym :=~) $_ $...)
          }
        PATTERN

        def on_send(node)
          check_match_assertion(node)
        end

        private

        def basic_preferred_assertion_method_name
          :assert
        end

        def preferred_assertion_method_name
          :assert_match
        end
      end
    end
  end
end
