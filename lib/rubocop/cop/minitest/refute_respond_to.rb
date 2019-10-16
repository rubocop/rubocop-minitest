# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the use of `refute_respond_to(object, :some_method)`
      # over `refute(object.respond_to?(:some_method))`.
      #
      # @example
      #   # bad
      #   refute(object.respond_to?(:some_method))
      #   refute(object.respond_to?(:some_method), 'the message')
      #
      #   # good
      #   refute_respond_to(object, :some_method)
      #   refute_respond_to(object, :some_method, 'the message')
      #
      class RefuteRespondTo < Cop
        MSG = 'Prefer using `refute_respond_to(%<preferred>s)` over ' \
              '`refute(%<over>s)`.'

        def_node_matcher :refute_with_respond_to, <<~PATTERN
          (send nil? :refute $(send $_ :respond_to? $_) $...)
        PATTERN

        def on_send(node)
          refute_with_respond_to(node) do |over, object, method, rest_args|
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
            refute_with_respond_to(node) do |_, object, method, rest_args|
              custom_message = rest_args.first
              preferred = [object, method, custom_message]
                          .compact.map(&:source).join(', ')
              replacement = "refute_respond_to(#{preferred})"
              corrector.replace(node.loc.expression, replacement)
            end
          end
        end
      end
    end
  end
end
