# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `assert_includes`
      # instead of using `assert(collection.include?(object))`.
      #
      # @example
      #   # bad
      #   assert(collection.include?(object))
      #   assert(collection.include?(object), 'the message')
      #
      #   # good
      #   assert_includes(collection, object)
      #   assert_includes(collection, object, 'the message')
      #
      class AssertIncludes < Cop
        include ArgumentRangeHelper

        MSG = 'Prefer using `assert_includes(%<arguments>s)` over ' \
              '`assert(%<receiver>s)`.'

        def_node_matcher :assert_with_includes, <<~PATTERN
          (send nil? :assert $(send $_ :include? $_) $...)
        PATTERN

        def on_send(node)
          assert_with_includes(node) do
            |first_receiver_arg, collection, actual, rest_receiver_arg|

            message = rest_receiver_arg.first
            arguments = node_arguments(collection, actual, message)
            receiver = [first_receiver_arg.source, message&.source].compact.join(', ')

            offense_message = format(MSG, arguments: arguments, receiver: receiver)

            add_offense(node, message: offense_message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            assert_with_includes(node) do |_, collection, actual|
              corrector.replace(node.loc.selector, 'assert_includes')

              replacement = [collection, actual].map(&:source).join(', ')
              corrector.replace(first_argument_range(node), replacement)
            end
          end
        end

        private

        def node_arguments(collection, actual, message)
          [collection.source, actual.source, message&.source].compact.join(', ')
        end
      end
    end
  end
end
