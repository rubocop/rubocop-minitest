# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This Cop checks for deprecated global expectations
      # and autocorrects them to use expect format.
      #
      # @example
      #   # bad
      #   n.must_equal 42
      #   n.wont_match b
      #
      #   # good
      #   _(n).must_equal 42
      #   _(n).wont_match b
      class GlobalExpectations < Cop
        MSG = 'Prefer using `%<corrected>s`.'

        VALUE_MATCHERS = %i[
          be be_close_to be_empty be_instance_of be_kind_of
          be_nil be_same_as be_silent be_within_epsilon equal
          include match respond_to must_exist
        ].map do |matcher|
          [:"must_#{matcher}", :"wont_#{matcher}"]
        end.flatten.freeze

        BLOCK_MATCHERS = %i[must_output must_raise must_throw].freeze

        MATCHERS_STR = (VALUE_MATCHERS + BLOCK_MATCHERS).map do |m|
          ":#{m}"
        end.join(' ').freeze

        def_node_matcher :global_expectation?, <<~PATTERN
          (send (send _ _) {#{MATCHERS_STR}} ...)
        PATTERN

        def on_send(node)
          return unless global_expectation?(node)

          message = format(MSG, corrected: correct_suggestion(node))
          add_offense(node, message: message)
        end

        def autocorrect(node)
          return unless global_expectation?(node)

          lambda do |corrector|
            receiver = node.receiver.loc.selector

            if BLOCK_MATCHERS.include?(node.method_name)
              corrector.insert_before(receiver, '_ { ')
              corrector.insert_after(receiver, ' }')
            else
              corrector.insert_before(receiver, '_(')
              corrector.insert_after(receiver, ')')
            end
          end
        end

        private

        def correct_suggestion(node)
          source = node.receiver.source
          if BLOCK_MATCHERS.include?(node.method_name)
            node.source.sub(source, "_ { #{source} }")
          else
            node.source.sub(source, "_(#{source})")
          end
        end
      end
    end
  end
end
