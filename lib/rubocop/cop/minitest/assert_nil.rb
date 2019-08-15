# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Check if your test uses `assert_nil` instead of `assert_equal(nil, something)`.
      #
      # @example
      #   # bad
      #   assert_equal(nil, actual)
      #   assert_equal(nil, actual, 'the message')
      #
      #   # good
      #   assert_nil(actual)
      #   assert_nil(actual, 'the message')
      #
      class AssertNil < Cop
        MSG = 'Prefer using `assert_nil(%<arguments>s)` over ' \
              '`assert_equal(nil, %<arguments>s)`.'

        def_node_matcher :assert_equal_with_nil, <<~PATTERN
          (send nil? :assert_equal nil $_ $...)
        PATTERN

        def on_send(node)
          assert_equal_with_nil(node) do |actual, message|
            message = message.first

            arguments = [actual.source, message&.source].compact.join(', ')

            add_offense(node, message: format(MSG, arguments: arguments))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            arguments = node.arguments.reject(&:nil_type?)
            replacement = arguments.map(&:source).join(', ')
            corrector.replace(node.loc.expression, "assert_nil(#{replacement})")
          end
        end
      end
    end
  end
end
