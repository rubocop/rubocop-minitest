# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `refute_includes`
      # instead of using `refute(collection.include?(object))`.
      #
      # @example
      #   # bad
      #   refute(collection.include?(object))
      #   refute(collection.include?(object), 'the message')
      #
      #   # good
      #   refute_includes(collection, object)
      #   refute_includes(collection, object, 'the message')
      #
      class RefuteIncludes < Cop
        MSG = 'Prefer using `refute_includes(%<arguments>s)` over ' \
              '`refute(%<receiver>s)`.'

        def_node_matcher :refute_with_includes, <<~PATTERN
          (send nil? :refute $(send $_ :include? $_) $...)
        PATTERN

        def on_send(node)
          refute_with_includes(node) do
            |first_receiver_arg, collection, object, rest_receiver_arg|

            message = rest_receiver_arg.first
            arguments = node_arguments(collection, object, message)
            receiver = [first_receiver_arg.source, message&.source].compact.join(', ')

            offense_message = format(MSG, arguments: arguments, receiver: receiver)

            add_offense(node, message: offense_message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            refute_with_includes(node) do
              |_receiver, collection, object, rest_receiver_arg|

              message = rest_receiver_arg.first
              replacement = node_arguments(collection, object, message)
              corrector.replace(node.loc.expression, "refute_includes(#{replacement})")
            end
          end
        end

        private

        def node_arguments(collection, object, message)
          [collection.source, object.source, message&.source].compact.join(', ')
        end
      end
    end
  end
end
