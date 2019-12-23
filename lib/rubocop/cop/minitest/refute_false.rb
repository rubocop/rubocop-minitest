# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the use of `refute(object)`
      # over `assert_equal(false, object)`.
      #
      # @example
      #   # bad
      #   assert_equal(false, actual)
      #   assert_equal(false, actual, 'the message')
      #
      #   # good
      #   refute(actual)
      #   refute(actual, 'the message')
      #
      class RefuteFalse < Cop
        include ArgumentRangeHelper

        MSG = 'Prefer using `refute(%<arguments>s)` over ' \
              '`assert_equal(false, %<arguments>s)`.'

        def_node_matcher :assert_equal_with_false, <<~PATTERN
          (send nil? :assert_equal false $_ $...)
        PATTERN

        def on_send(node)
          assert_equal_with_false(node) do |actual, rest_receiver_arg|
            message = rest_receiver_arg.first

            arguments = [actual.source, message&.source].compact.join(', ')

            add_offense(node, message: format(MSG, arguments: arguments))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            assert_equal_with_false(node) do |actual|
              corrector.replace(node.loc.selector, 'refute')
              corrector.replace(
                first_and_second_arguments_range(node), actual.source
              )
            end
          end
        end
      end
    end
  end
end
