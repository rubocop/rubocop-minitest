# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces that there is only one definition for
      # each hook type.
      #
      # It may be expected that multiple hook definitions
      # of the same type are merged somehow, but they only
      # override previous definitions.
      #
      # @example
      #   # bad
      #   class FooTest < Minitest::Test
      #
      #     # Will not be executed
      #     def setup
      #       setup_something
      #     end
      #
      #     # This will override previous setup hook
      #     def setup
      #       setup_something_else
      #     end
      #   end
      #
      #   # good
      #   class FooTest < Minitest::Test
      #     def setup
      #       setup_something
      #       setup_something_else
      #     end
      #   end
      #
      class OverridenHook < Cop
        include MinitestExplorationHelpers

        MSG = 'This `:%<hook_name>s` hook overrides previously defined `:%<hook_name>s` hook.'

        def on_class(class_node)
          return unless minitest_test_subclass?(class_node)

          seen_hooks = {}

          class_elements(class_node).each do |node|
            next unless hook?(node)

            hook_name = node.method_name
            if seen_hooks.key?(hook_name)
              message = format(MSG, hook_name: hook_name)
              add_offense(node, location: :name, message: message)
            else
              seen_hooks[hook_name] = true
            end
          end
        end

        private

        def class_elements(class_node)
          class_def = class_node.body
          return [] unless class_def

          if class_def.def_type?
            [class_def]
          else
            class_def.each_child_node(:def).to_a
          end
        end
      end
    end
  end
end
