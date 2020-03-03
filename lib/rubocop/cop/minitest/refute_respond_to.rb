# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `refute_respond_to(object, :do_something)`
      # over `refute(object.respond_to?(:do_something))`.
      #
      # @example
      #   # bad
      #   refute(object.respond_to?(:do_something))
      #   refute(object.respond_to?(:do_something), 'message')
      #   refute(respond_to?(:do_something))
      #
      #   # good
      #   refute_respond_to(object, :do_something)
      #   refute_respond_to(object, :do_something, 'message')
      #   refute_respond_to(self, :do_something)
      #
      class RefuteRespondTo < Cop
        include ArgumentRangeHelper

        MSG = 'Prefer using `refute_respond_to(%<preferred>s)` over ' \
              '`refute(%<over>s)`.'

        def_node_matcher :refute_with_respond_to, <<~PATTERN
          (send nil? :refute $(send $_ :respond_to? $_) $...)
        PATTERN

        def on_send(node)
          refute_with_respond_to(node) do |over, object, method, rest_args|
            custom_message = rest_args.first
            preferred = build_preferred_arguments(object, method, custom_message)
            over = [over, custom_message].compact.map(&:source).join(', ')
            message = format(MSG, preferred: preferred, over: over)
            add_offense(node, message: message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            refute_with_respond_to(node) do |_, object, method|
              corrector.replace(node.loc.selector, 'refute_respond_to')

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
