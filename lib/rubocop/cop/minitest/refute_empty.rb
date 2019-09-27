# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Check if your test uses `refute_empty` instead of `refute(actual.empty?)`.
      #
      # @example
      #   # bad
      #   assert(actual.empty?)
      #   assert(actual.empty?, 'the message')
      #
      #   # good
      #   refute_empty(actual)
      #   refute_empty(actual, 'the message')
      #
      class RefuteEmpty < Cop
        MSG = 'Prefer using `refute_empty(%<arguments>s)` over ' \
              '`refute(%<receiver>s)`.'

        def_node_matcher :refute_with_empty, <<~PATTERN
          (send nil? :refute $(send $_ :empty?) $...)
        PATTERN

        def on_send(node)
          refute_with_empty(node) do |first_receiver_arg, actual, rest_receiver_arg|
            message = rest_receiver_arg.first

            arguments = [actual.source, message&.source].compact.join(', ')
            receiver = [first_receiver_arg.source, message&.source].compact.join(', ')

            offense_message = format(MSG, arguments: arguments, receiver: receiver)
            add_offense(node, message: offense_message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            refute_with_empty(node) do |_first_receiver_arg, actual, rest_receiver_arg|
              message = rest_receiver_arg.first

              replacement = [actual.source, message&.source].compact.join(', ')
              corrector.replace(node.loc.expression, "refute_empty(#{replacement})")
            end
          end
        end
      end
    end
  end
end
