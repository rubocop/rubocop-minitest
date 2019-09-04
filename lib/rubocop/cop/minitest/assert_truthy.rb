# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Check if your test uses `assert(actual)`
      # instead of `assert_equal(true, actual)`.
      #
      # @example
      #   # bad
      #   assert_equal(true, actual)
      #   assert_equal(true, actual, 'the message')
      #
      #   # good
      #   assert(actual)
      #   assert(actual, 'the message')
      #
      class AssertTruthy < Cop
        MSG = 'Prefer using `assert(%<arguments>s)` over ' \
              '`assert_equal(true, %<arguments>s)`.'

        def_node_matcher :assert_equal_with_truthy, <<~PATTERN
          (send nil? :assert_equal true $_ $...)
        PATTERN

        def on_send(node)
          assert_equal_with_truthy(node) do |actual, rest_receiver_arg|
            message = rest_receiver_arg.first

            arguments = [actual.source, message&.source].compact.join(', ')

            add_offense(node, message: format(MSG, arguments: arguments))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            arguments = node.arguments.reject(&:true_type?)
            replacement = arguments.map(&:source).join(', ')
            corrector.replace(node.loc.expression, "assert(#{replacement})")
          end
        end
      end
    end
  end
end
