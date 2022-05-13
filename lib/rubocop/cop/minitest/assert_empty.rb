# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the test to use `assert_empty` instead of using `assert(object.empty?)`.
      #
      # @example
      #   # bad
      #   assert(object.empty?)
      #   assert(object.empty?, 'message')
      #
      #   # good
      #   assert_empty(object)
      #   assert_empty(object, 'message')
      #
      class AssertEmpty < Base
        extend MinitestCopRule

        define_rule :assert, target_method: :empty?

        remove_method :on_send
        def on_send(node)
          return unless node.method?(:assert)
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
