# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the use of `refute_instance_of(Class, object)`
      # over `refute(object.instance_of?(Class))`.
      #
      # @example
      #   # bad
      #   refute(object.instance_of?(Class))
      #   refute(object.instance_of?(Class), 'the message')
      #
      #   # good
      #   refute_instance_of(Class, object)
      #   refute_instance_of(Class, object, 'the message')
      #
      class RefuteInstanceOf < Cop
        MSG = 'Prefer using `refute_instance_of(%<arguments>s)` over ' \
              '`refute(%<receiver>s)`.'

        def_node_matcher :refute_with_instance_of, <<~PATTERN
          (send nil? :refute $(send $_ :instance_of? $_) $...)
        PATTERN

        def on_send(node)
          refute_with_instance_of(node) do
            |first_receiver_arg, object, method, rest_args|

            message = rest_args.first
            arguments = node_arguments(object, method, message)
            receiver = [first_receiver_arg.source, message&.source].compact.join(', ')

            offense_message = format(MSG, arguments: arguments, receiver: receiver)

            add_offense(node, message: offense_message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            refute_with_instance_of(node) do |_, object, method, rest_args|
              message = rest_args.first
              arguments = node_arguments(object, method, message)

              replacement = "refute_instance_of(#{arguments})"
              corrector.replace(node.loc.expression, replacement)
            end
          end
        end

        private

        def node_arguments(object, method, message)
          [method, object, message].compact.map(&:source).join(', ')
        end
      end
    end
  end
end
