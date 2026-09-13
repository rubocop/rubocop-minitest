# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the test to use `refute_match`
      # instead of using `refute(matcher.match(string))`.
      #
      # The autocorrection is applied only when one of the operands is a regexp
      # literal, so that the `refute_match(matcher, string)` argument order can be
      # determined. Otherwise the offense is reported without a correction,
      # because `a.match?(b)` is ambiguous: both `String#match?` and
      # `Regexp#match?` exist.
      #
      # @example
      #   # bad
      #   refute(matcher.match(string))
      #   refute(matcher.match?(string))
      #   refute(matcher =~ string)
      #   refute_operator(matcher, :=~, string)
      #   assert_operator(matcher, :!~, string)
      #   refute(matcher.match(string), 'message')
      #
      #   # good
      #   refute_match(matcher, string)
      #   refute_match(matcher, string, 'message')
      #
      class RefuteMatch < Base
        include ArgumentRangeHelper
        extend AutoCorrector

        MSG = 'Prefer using `refute_match(%<preferred>s)`.'
        RESTRICT_ON_SEND = %i[refute refute_operator assert_operator].freeze

        def_node_matcher :refute_match, <<~PATTERN
          {
            (send nil? :refute (send $_ {:match :match? :=~} $_) $...)
            (send nil? :refute_operator $_ (sym :=~) $_ $...)
            (send nil? :assert_operator $_ (sym :!~) $_ $...)
          }
        PATTERN

        def on_send(node)
          refute_match(node) do |expected, actual, rest_args|
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
          corrector.replace(node.loc.selector, 'refute_match')

          range = if node.method?(:refute)
                    node.first_argument
                  else
                    node.first_argument.source_range.begin.join(node.arguments[2].source_range.end)
                  end

          corrector.replace(range, basic_arguments)
        end

        # `a.match?(b)` accepts either operand as the pattern (`String#match?` and
        # `Regexp#match?` both exist), so the `refute_match(matcher, string)` order
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
