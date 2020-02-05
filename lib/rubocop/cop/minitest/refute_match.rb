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
        include ArgumentRangeHelper

        MSG = 'Prefer using `refute_match(%<arguments>s)` over ' \
              '`refute(%<receiver>s)`.'

        def_node_matcher :refute_with_match, <<~PATTERN
          (send nil? :refute $(send $_ :match $_) $...)
        PATTERN

        def on_send(node)
          refute_with_match(node) do
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
            refute_with_match(node) do |_, matcher, actual|
              corrector.replace(node.loc.selector, 'refute_match')

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
