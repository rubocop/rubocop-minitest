# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `assert_empty`
      # instead of using `assert(actual.empty?)`.
      #
      # @example
      #   # bad
      #   assert(actual.empty?)
      #   assert(actual.empty?, 'the message')
      #
      #   # good
      #   assert_empty(actual)
      #   assert_empty(actual, 'the message')
      #
      class AssertEmpty < Cop
        MSG = 'Prefer using `assert_empty(%<arguments>s)` over ' \
              '`assert(%<receiver>s)`.'

        def_node_matcher :assert_with_empty, <<~PATTERN
          (send nil? :assert $(send $_ :empty?) $...)
        PATTERN

        def on_send(node)
          assert_with_empty(node) do |first_receiver_arg, actual, rest_receiver_arg|
            message = rest_receiver_arg.first

            arguments = [actual.source, message&.source].compact.join(', ')
            receiver = [first_receiver_arg.source, message&.source].compact.join(', ')

            offense_message = format(MSG, arguments: arguments, receiver: receiver)
            add_offense(node, message: offense_message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            assert_with_empty(node) do |_first_receiver_arg, actual, rest_receiver_arg|
              message = rest_receiver_arg.first

              replacement = [actual.source, message&.source].compact.join(', ')
              corrector.replace(node.loc.expression, "assert_empty(#{replacement})")
            end
          end
        end
      end
    end
  end
end
