# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `assert_instance_of(Class, object)`
      # over `assert(object.instance_of?(Class))`.
      #
      # @example
      #   # bad
      #   assert(object.instance_of?(Class))
      #   assert(object.instance_of?(Class), 'the message')
      #
      #   # good
      #   assert_instance_of(Class, object)
      #   assert_instance_of(Class, object, 'the message')
      #
      class AssertInstanceOf < Cop
        include ArgumentRangeHelper

        MSG = 'Prefer using `assert_instance_of(%<arguments>s)` over ' \
              '`assert(%<receiver>s)`.'

        def_node_matcher :assert_with_instance_of, <<~PATTERN
          (send nil? :assert $(send $_ :instance_of? $_) $...)
        PATTERN

        def on_send(node)
          assert_with_instance_of(node) do |first_receiver_arg, object, method, rest_args|
            message = rest_args.first
            arguments = node_arguments(object, method, message)
            receiver = [first_receiver_arg.source, message&.source].compact.join(', ')

            offense_message = format(MSG, arguments: arguments, receiver: receiver)

            add_offense(node, message: offense_message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            assert_with_instance_of(node) do |_, object, method|
              corrector.replace(node.loc.selector, 'assert_instance_of')

              replacement = [method, object].map(&:source).join(', ')
              corrector.replace(first_argument_range(node), replacement)
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
