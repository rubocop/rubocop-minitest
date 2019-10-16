# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the use of `assert_equal(expected, actual)`
      # over `assert(expected == actual)`.
      #
      # @example
      #   # bad
      #   assert("rubocop-minitest" == actual)
      #
      #   # good
      #   assert_equal("rubocop-minitest", actual)
      #
      class AssertEqual < Cop
        MSG = 'Prefer using `assert_equal(%<preferred>s)` over ' \
              '`assert(%<over>s)`.'

        def_node_matcher :assert_equal, <<~PATTERN
          (send nil? :assert $(send $_ :== $_) $...)
        PATTERN

        def on_send(node)
          assert_equal(node) do
            |first_receiver_arg, expected, actual, rest_receiver_arg|

            message = rest_receiver_arg.first
            preferred = [expected.source, actual.source, message&.source]
                        .compact.join(', ')
            over = [first_receiver_arg.source, message&.source].compact.join(', ')

            offense_message = format(MSG, preferred: preferred, over: over)

            add_offense(node, message: offense_message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            assert_equal(node) do |_receiver, expected, actual, rest_receiver_arg|
              message = rest_receiver_arg.first
              replacement = node_arguments(expected, actual, message)
              corrector.replace(node.loc.expression, "assert_equal(#{replacement})")
            end
          end
        end

        private

        def node_arguments(expected, actual, message)
          [expected.source, actual.source, message&.source].compact.join(', ')
        end
      end
    end
  end
end
