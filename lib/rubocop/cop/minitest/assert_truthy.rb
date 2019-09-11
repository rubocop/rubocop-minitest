# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Check if your test uses `assert(actual)`
      # instead of `assert_equal(true, actual)` &
      # `refute(actual)` instead of `refute_equal(true, actual)`
      #
      # @example
      #   # bad
      #   assert_equal(true, actual)
      #   assert_equal(true, actual, 'the message')
      #   refute_equal(true, actual)
      #   refute_equal(true, actual, 'the message')
      #
      #   # good
      #   assert(actual)
      #   assert(actual, 'the message')
      #   refute(actual)
      #   refute(actual, 'the message')
      #
      class AssertTruthy < Cop
        MSG = 'Prefer using `%{replacement}(%<arguments>s)` over ' \
              '`%{assertion}(true, %<arguments>s)`.'

        def_node_matcher :assert_equal_with_truthy, <<~PATTERN
          (send nil? ${:assert_equal :refute_equal} true $_ $...)
        PATTERN

        def on_send(node)
          assert_equal_with_truthy(node) do |assertion, actual, rest_args|
            message = rest_args.first

            arguments = [actual.source, message&.source].compact.join(', ')
            add_offense(node, message: message(assertion, arguments))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            arguments = node.arguments
                            .reject(&:true_type?)
                            .map(&:source).join(', ')
            corrected = "#{replacement(node.children[1])}(#{arguments})"
            corrector.replace(node.loc.expression, corrected)
          end
        end

        private

        def message(assertion, arguments)
          format(MSG, assertion: assertion, replacement: replacement(assertion),
                      arguments: arguments)
        end

        def replacement(method_name)
          method_name == :assert_equal ? :assert : :refute
        end
      end
    end
  end
end
