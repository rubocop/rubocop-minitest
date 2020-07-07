# frozen_string_literal: true

module RuboCop
  module Cop
    # Common functionality for `AssertInDelta` and `RefuteInDelta` cops.
    module InDeltaMixin
      MSG = 'Prefer using `%<good_method>s` over `%<bad_method>s`.'

      def on_send(node)
        equal_floats_call(node) do |expected, actual, message|
          message = message.first

          if expected.float_type? || actual.float_type?
            message = format(MSG,
                             good_method: build_good_method(expected, actual, message),
                             bad_method: node.source)

            add_offense(node, message: message)
          end
        end
      end

      def autocorrect(node)
        equal_floats_call(node) do |expected, actual, message|
          message = message.first
          replacement = build_good_method(expected, actual, message)

          lambda do |corrector|
            corrector.replace(node, replacement)
          end
        end
      end

      private

      def build_good_method(expected, actual, message)
        if message
          "#{assertion_method}_in_delta(#{expected.source}, #{actual.source}, 0.001, #{message.source})"
        else
          "#{assertion_method}_in_delta(#{expected.source}, #{actual.source})"
        end
      end

      def assertion_method
        class_name = self.class.name.split('::').last
        class_name[/\A[[:upper:]][[:lower:]]+/].downcase
      end
    end
  end
end
