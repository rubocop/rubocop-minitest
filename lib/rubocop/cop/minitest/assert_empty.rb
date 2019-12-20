# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `assert_empty`
      # instead of using `assert(object.empty?)`.
      #
      # @example
      #   # bad
      #   assert(object.empty?)
      #   assert(object.empty?, 'the message')
      #
      #   # good
      #   assert_empty(object)
      #   assert_empty(object, 'the message')
      #
      class AssertEmpty < Cop
        include ArgumentRangeHelper

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
            assert_with_empty(node) do |_, actual_arg|
              corrector.replace(node.loc.selector, 'assert_empty')
              corrector.replace(first_argument_range(node), actual_arg.source)
            end
          end
        end
      end
    end
  end
end
