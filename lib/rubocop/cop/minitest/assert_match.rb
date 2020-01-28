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
        include ArgumentRangeHelper

        MSG = 'Prefer using `assert_match(%<arguments>s)` over ' \
              '`assert(%<receiver>s)`.'

        def_node_matcher :assert_with_match, <<~PATTERN
          (send nil? :assert $(send $_ :match $_) $...)
        PATTERN

        def on_send(node)
          assert_with_match(node) do
            |first_receiver_arg, matcher, actual, rest_receiver_arg|
            message = rest_receiver_arg.first
            arguments = node_arguments(matcher, actual, message)
            receiver = [first_receiver_arg.source, message&.source].compact.join(', ')

            offense_message = format(MSG, arguments: arguments, receiver: receiver)

            add_offense(node, message: offense_message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            assert_with_match(node) do |_, matcher, actual|
              corrector.replace(node.loc.selector, 'assert_match')

              replacement = [matcher, actual].map(&:source).join(', ')
              corrector.replace(first_argument_range(node), replacement)
            end
          end
        end

        private

        def node_arguments(matcher, actual, message)
          [matcher.source, actual.source, message&.source].compact.join(', ')
        end
      end
    end
  end
end
