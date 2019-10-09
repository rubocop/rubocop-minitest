# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `refute_nil`
      # instead of using `refute_equal(nil, something)`.
      #
      # @example
      #   # bad
      #   refute_equal(nil, actual)
      #   refute_equal(nil, actual, 'the message')
      #
      #   # good
      #   refute_nil(actual)
      #   refute_nil(actual, 'the message')
      #
      class RefuteNil < Cop
        MSG = 'Prefer using `refute_nil(%<arguments>s)` over ' \
              '`refute_equal(nil, %<arguments>s)`.'

        def_node_matcher :refute_equal_with_nil, <<~PATTERN
          (send nil? :refute_equal nil $_ $...)
        PATTERN

        def on_send(node)
          refute_equal_with_nil(node) do |actual, message|
            message = message.first

            arguments = [actual.source, message&.source].compact.join(', ')

            add_offense(node, message: format(MSG, arguments: arguments))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            arguments = node.arguments.reject(&:nil_type?)
            replacement = arguments.map(&:source).join(', ')
            corrector.replace(node.loc.expression, "refute_nil(#{replacement})")
          end
        end
      end
    end
  end
end
