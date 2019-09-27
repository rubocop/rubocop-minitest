# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces to use `refute_empty` instead of
      # using `refute(object.empty?)`.
      #
      # @example
      #   # bad
      #   refute(object.empty?)
      #   refute(object.empty?, 'the message')
      #
      #   # good
      #   refute_empty(object)
      #   refute_empty(object, 'the message')
      #
      class RefuteEmpty < Cop
        MSG = 'Prefer using `refute_empty(%<arguments>s)` over ' \
              '`refute(%<receiver>s)`.'

        def_node_matcher :refute_with_empty, <<~PATTERN
          (send nil? :refute $(send $_ :empty?) $...)
        PATTERN

        def on_send(node)
          refute_with_empty(node) do |first_receiver_arg, object, rest_receiver_arg|
            message = rest_receiver_arg.first

            arguments = [object.source, message&.source].compact.join(', ')
            receiver = [first_receiver_arg.source, message&.source].compact.join(', ')

            offense_message = format(MSG, arguments: arguments, receiver: receiver)
            add_offense(node, message: offense_message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            refute_with_empty(node) do |_first_receiver_arg, object, rest_receiver_arg|
              message = rest_receiver_arg.first

              replacement = [object.source, message&.source].compact.join(', ')
              corrector.replace(node.loc.expression, "refute_empty(#{replacement})")
            end
          end
        end
      end
    end
  end
end
