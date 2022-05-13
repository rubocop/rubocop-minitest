# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces to use `refute_empty` instead of using `refute(object.empty?)`.
      #
      # @example
      #   # bad
      #   refute(object.empty?)
      #   refute(object.empty?, 'message')
      #
      #   # good
      #   refute_empty(object)
      #   refute_empty(object, 'message')
      #
      class RefuteEmpty < Base
        extend MinitestCopRule

        define_rule :refute, target_method: :empty?

        remove_method :on_send
        def on_send(node)
          return unless node.method?(:refute)
          return unless (arguments = peel_redundant_parentheses_from(node.arguments))
          return unless arguments.first.respond_to?(:method?) && arguments.first.method?(:empty?)
          return unless arguments.first.arguments.empty?

          add_offense(node, message: offense_message(arguments)) do |corrector|
            autocorrect(corrector, node, arguments)
          end
        end
      end
    end
  end
end
