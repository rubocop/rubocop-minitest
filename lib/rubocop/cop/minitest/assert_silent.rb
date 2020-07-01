# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `assert_silent { ... }`
      # instead of using `assert_output('', '') { ... }`.
      #
      # @example
      #   # bad
      #   assert_output('', '') { puts object.do_something }
      #
      #   # good
      #   assert_silent { puts object.do_something }
      #
      class AssertSilent < Cop
        MSG = 'Prefer using `assert_silent` over `assert_output("", "")`.'

        def_node_matcher :assert_silent_candidate?, <<~PATTERN
          (block
            (send nil? :assert_output
              #empty_string?
              #empty_string?)
            ...)
        PATTERN

        def on_block(node)
          add_offense(node.send_node) if assert_silent_candidate?(node)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node, 'assert_silent')
          end
        end

        private

        def empty_string?(node)
          node.str_type? && node.value.empty?
        end
      end
    end
  end
end
