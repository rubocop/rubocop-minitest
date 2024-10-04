# frozen_string_literal: true

module RuboCop
  module Cop
    # Common implementation for `AssertMatch` and `RefuteMatch` cops.
    module AssertRefuteMatchHelper
      private

      def check_match_assertion(node)
        match_assertion(node) do |expected, actual, rest_args|
          basic_arguments = order_expected_and_actual(expected, actual)

          add_offense(node, message: format_message(basic_arguments, rest_args)) do |corrector|
            corrector.replace(node.loc.selector, preferred_assertion_method_name)
            corrector.replace(assertion_arguments_range(node), basic_arguments)
          end
        end
      end

      def format_message(basic_arguments, rest_args)
        preferred = (message_arg = rest_args.first) ? "#{basic_arguments}, #{message_arg.source}" : basic_arguments

        format(self.class::MSG, preferred: preferred)
      end

      def assertion_arguments_range(node)
        if node.method?(basic_preferred_assertion_method_name)
          node.first_argument
        else
          node.first_argument.source_range.begin.join(node.arguments[2].source_range.end)
        end
      end

      def order_expected_and_actual(expected, actual)
        if actual.regexp_type?
          [actual, expected]
        else
          [expected, actual]
        end.map(&:source).join(', ')
      end
    end
  end
end
