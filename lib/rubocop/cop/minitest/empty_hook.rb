# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop checks for empty hooks.
      #
      # @example
      #   # bad
      #   class FooTest < Minitest::Test
      #     def setup
      #     end
      #   end
      #
      #   # good
      #   class FooTest < Minitest::Test
      #     def setup
      #       setup_something
      #     end
      #   end
      #
      class EmptyHook < Cop
        include MinitestExplorationHelpers

        MSG = 'Empty hook detected.'

        def on_class(class_node)
          return unless minitest_test_subclass?(class_node)

          hooks(class_node).each do |node|
            add_offense(node) if node.body.nil?
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.remove(node)
          end
        end
      end
    end
  end
end
