# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the use of `assert_respond_to(object, :some_method)`
      # over `assert(object.respond_to?(:some_method))`.
      #
      # @example
      #   # bad
      #   assert(object.respond_to?(:some_method))
      #   assert(object.respond_to?(:some_method), 'the message')
      #   assert(respond_to?(:some_method))
      #
      #   # good
      #   assert_respond_to(object, :some_method)
      #   assert_respond_to(object, :some_method, 'the message')
      #   assert_respond_to(self, some_method)
      #
      class AssertRespondTo < Cop
        include ArgumentRangeHelper

        MSG = 'Prefer using `assert_respond_to(%<preferred>s)` over ' \
              '`assert(%<over>s)`.'

        def_node_matcher :assert_with_respond_to, <<~PATTERN
          (send nil? :assert $(send $_ :respond_to? $_) $...)
        PATTERN

        def on_send(node)
          assert_with_respond_to(node) do |over, object, method, rest_args|
            custom_message = rest_args.first
            preferred = build_preferred_arguments(object, method, custom_message)
            over = [over, custom_message].compact.map(&:source).join(', ')
            message = format(MSG, preferred: preferred, over: over)
            add_offense(node, message: message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            assert_with_respond_to(node) do |_, object, method|
              corrector.replace(node.loc.selector, 'assert_respond_to')

              object = object ? object.source : 'self'
              replacement = [object, method.source].join(', ')
              corrector.replace(first_argument_range(node), replacement)
            end
          end
        end

        private

        def build_preferred_arguments(receiver, method, message)
          receiver = receiver ? receiver.source : 'self'

          [receiver, method.source, message&.source].compact.join(', ')
        end
      end
    end
  end
end
