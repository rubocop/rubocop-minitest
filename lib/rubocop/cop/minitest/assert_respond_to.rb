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
      #
      #   # good
      #   assert_respond_to(object, :some_method)
      #   assert_respond_to(object, :some_method, 'the message')
      #
      class AssertRespondTo < Cop
        MSG = 'Prefer using `assert_respond_to(%<preferred>s)` over ' \
              '`assert(%<over>s)`.'

        def_node_matcher :assert_with_respond_to, <<~PATTERN
          (send nil? :assert $(send $_ :respond_to? $_) $...)
        PATTERN

        def on_send(node)
          assert_with_respond_to(node) do |over, object, method, rest_args|
            custom_message = rest_args.first
            preferred = [object, method, custom_message]
                        .compact.map(&:source).join(', ')
            over      = [over, custom_message].compact.map(&:source).join(', ')
            message = format(MSG, preferred: preferred, over: over)
            add_offense(node, message: message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            assert_with_respond_to(node) do |_, object, method, rest_args|
              custom_message = rest_args.first
              preferred = [object, method, custom_message]
                          .compact.map(&:source).join(', ')
              replacement = "assert_respond_to(#{preferred})"
              corrector.replace(node.loc.expression, replacement)
            end
          end
        end
      end
    end
  end
end
