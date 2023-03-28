# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the use of `refute_equal(expected, object)`
      # over `assert(expected != actual)` or `assert(! expected == actual)`.
      #
      # @example
      #   # bad
      #   assert("rubocop-minitest" != actual)
      #   assert(! "rubocop-minitest" == actual)
      #
      #   # good
      #   refute_equal("rubocop-minitest", actual)
      #
      class RefuteEqual < Base
        include ArgumentRangeHelper
        extend AutoCorrector

        MSG = 'Prefer using `refute_equal(%<preferred>s)`.'
        RESTRICT_ON_SEND = %i[assert].freeze

        def_node_matcher :assert_not_equal, <<~PATTERN
          (send nil? :assert {(send $_ :!= $_) (send (send $_ :! ) :== $_) } $... )
        PATTERN

        def on_send(node)
          preferred = process_not_equal(node)
          return unless preferred

          assert_not_equal(node) do |expected, actual|
            message = format(MSG, preferred: preferred)

            add_offense(node, message: message) do |corrector|
              corrector.replace(node.loc.selector, 'refute_equal')

              replacement = [expected, actual].map(&:source).join(', ')
              corrector.replace(node.first_argument, replacement)
            end
          end
        end

        private

        def preferred_usage(first_arg, second_arg, custom_message = nil)
          [first_arg, second_arg, custom_message].compact.map(&:source).join(', ')
        end

        def original_usage(first_part, custom_message)
          [first_part, custom_message].compact.join(', ')
        end

        def process_not_equal(node)
          assert_not_equal(node) do |first_arg, second_arg, rest_args|
            custom_message = rest_args.first

            preferred_usage(first_arg, second_arg, custom_message)
          end
        end
      end
    end
  end
end
