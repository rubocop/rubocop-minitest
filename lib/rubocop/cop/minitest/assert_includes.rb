# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the test to use `assert_includes`
      # instead of using `assert(collection.include?(object))`.
      #
      # @example
      #   # bad
      #   assert(collection.include?(object))
      #   assert(collection.include?(object), 'message')
      #
      #   # good
      #   assert_includes(collection, object)
      #   assert_includes(collection, object, 'message')
      #
      class AssertIncludes < Base
        extend MinitestCopRule

        define_rule :assert, target_method: %i[include? member?], preferred_method: :assert_includes

        remove_method :on_send
        def on_send(node)
          handle_assert(node)
        end

        private

        # Handle assert(collection.include?(object))
        def handle_assert(node)
          return unless node.method?(:assert)

          receiver = node.first_argument
          return unless receiver&.call_type?
          return if %i[include? member?].none? { |target_method| receiver.method?(target_method) }
          return unless single_positional_argument?(receiver)

          add_offense(node, message: offense_message(node.arguments)) do |corrector|
            autocorrect(corrector, node, node.arguments)
          end
        end
      end
    end
  end
end
