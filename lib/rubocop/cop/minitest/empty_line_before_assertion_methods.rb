# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces empty line before assertion methods because it separates assertion phase.
      #
      # @example
      #
      #   # bad
      #   do_something
      #   assert_equal(expected, actual)
      #
      #   # good
      #   do_something
      #
      #   assert_equal(expected, actual)
      #
      class EmptyLineBeforeAssertionMethods < Base
        include MinitestExplorationHelpers
        include RangeHelp
        extend AutoCorrector

        MSG = 'Add empty line before assertion.'

        def on_send(node)
          return unless assertion_method?(node)
          return unless (previous_line_node = node.left_sibling)
          return unless previous_line_node.is_a?(RuboCop::AST::Node)
          return if accept_previous_line?(previous_line_node, node)

          previous_line_node = previous_line_node.arguments.last if use_heredoc_argument?(previous_line_node)
          return unless no_empty_line?(previous_line_node, node)

          register_offense(node, previous_line_node)
        end

        private

        def accept_previous_line?(previous_line_node, node)
          return true if previous_line_node.args_type? || node.parent.basic_conditional?

          previous_line_node.send_type? && assertion_method?(previous_line_node)
        end

        def use_heredoc_argument?(node)
          node.respond_to?(:arguments) && heredoc?(node.arguments.last)
        end

        def heredoc?(last_argument)
          last_argument.respond_to?(:heredoc?) && last_argument.heredoc?
        end

        def no_empty_line?(previous_line_node, node)
          previous_line = if heredoc?(previous_line_node)
                            previous_line_node.loc.heredoc_end.line
                          else
                            previous_line_node.loc.last_line
                          end

          previous_line + 1 == node.loc.line
        end

        def register_offense(node, previous_line_node)
          add_offense(node) do |corrector|
            range = if heredoc?(previous_line_node)
                      previous_line_node.loc.heredoc_end
                    else
                      range_by_whole_lines(previous_line_node.source_range, include_final_newline: true)
                    end

            corrector.insert_after(range, "\n")
          end
        end
      end
    end
  end
end
