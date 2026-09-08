# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the test to use `assert_match`
      # instead of using `assert(matcher.match(string))`.
      #
      # The autocorrection is applied only when one of the operands is a regexp
      # literal, so that the `assert_match(matcher, string)` argument order can be
      # determined. Otherwise the offense is reported without a correction,
      # because `a.match?(b)` is ambiguous: both `String#match?` and
      # `Regexp#match?` exist.
      #
      # @example
      #   # bad
      #   assert(matcher.match(string))
      #   assert(matcher.match?(string))
      #   assert(matcher =~ string)
      #   assert_operator(matcher, :=~, string)
      #   assert(matcher.match(string), 'message')
      #
      #   # good
      #   assert_match(regex, string)
      #   assert_match(matcher, string, 'message')
      #
      class AssertMatch < Base
        include ArgumentRangeHelper
        extend AutoCorrector

        MSG = 'Prefer using `assert_match(%<preferred>s)`.'
        RESTRICT_ON_SEND = %i[assert assert_operator].freeze

        def_node_matcher :assert_match, <<~PATTERN
          {
            (send nil? :assert (send $_ {:match :match? :=~} $_) $...)
            (send nil? :assert_operator $_ (sym :=~) $_ $...)
          }
        PATTERN

        def on_send(node)
          assert_match(node) do |expected, actual, rest_args|
            basic_arguments = order_expected_and_actual(expected, actual)
            preferred = (message_arg = rest_args.first) ? "#{basic_arguments}, #{message_arg.source}" : basic_arguments
            message = format(MSG, preferred: preferred)

            if determinable_order?(expected, actual)
              add_offense(node, message: message) { |corrector| autocorrect(corrector, node, basic_arguments) }
            else
              add_offense(node, message: message)
            end
          end
        end

        private

        def autocorrect(corrector, node, basic_arguments)
          corrector.replace(node.loc.selector, 'assert_match')

          range = if node.method?(:assert)
                    node.first_argument
                  else
                    node.first_argument.source_range.begin.join(node.arguments[2].source_range.end)
                  end

          corrector.replace(range, basic_arguments)
        end

        # `a.match?(b)` accepts either operand as the pattern (`String#match?` and
        # `Regexp#match?` both exist), so the `assert_match(matcher, string)` order
        # is only known when one operand is a regexp literal.
        def determinable_order?(expected, actual)
          expected.regexp_type? || actual.regexp_type?
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
end
