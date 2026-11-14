# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Checks for expectations whose only argument is a hash without braces.
      #
      # The behavior of braceless hash arguments to expectations changed in Minitest 6.1. Prior to the change,
      # `_(actual).must_equal(a: 1)` compared `actual` with `{a: 1}`. From Minitest 6.1 onwards, `a: 1` is treated as
      # keyword arguments, and the expected value becomes `nil`. As a result, `must_equal` fails with
      # "Use assert_nil if expecting nil." and `wont_equal` passes silently.
      #
      # Only the expectations that pass their argument as the expected value of an equality or identity assertion are
      # checked: `must_equal`, `wont_equal`, `must_be_same_as`, and `wont_be_same_as`.
      #
      # @safety
      #   This cop's autocorrection is unsafe because it changes how the expectation behaves on Minitest 6.1 and later:
      #   an expectation that used to pass (e.g. `wont_equal`) may start failing.
      #
      # @example
      #   # bad
      #   _(actual).must_equal(a: 1)
      #   _(actual).wont_equal(a: 1, **other)
      #   _(actual).must_equal(**expected)
      #
      #   # good
      #   _(actual).must_equal({a: 1})
      #   _(actual).wont_equal({a: 1, **other})
      #   _(actual).must_equal(expected)
      #
      class ExpectationImplicitHash < Base
        extend AutoCorrector

        MSG = 'Wrap the expected hash in braces; without them, it is passed as keyword arguments.'
        MSG_DOUBLE_SPLAT = 'Pass the expected hash without `**`; with it, it is passed as keyword arguments.'

        RESTRICT_ON_SEND = %i[must_equal wont_equal must_be_same_as wont_be_same_as].freeze

        def_node_matcher :implicit_hash_argument, <<~PATTERN
          (call !nil? _ $(hash ...))
        PATTERN

        def_node_matcher :double_splat, <<~PATTERN
          (hash (kwsplat $_))
        PATTERN

        def on_send(node)
          implicit_hash_argument(node) do |hash|
            return if hash.braces?

            if (expected = double_splat(hash))
              add_offense(hash, message: MSG_DOUBLE_SPLAT) do |corrector|
                corrector.replace(hash, expected.source)
              end
            else
              add_offense(hash) do |corrector|
                autocorrect(corrector, node, hash)
              end
            end
          end
        end
        alias on_csend on_send

        private

        def autocorrect(corrector, node, hash)
          if node.parenthesized?
            corrector.wrap(hash, '{', '}')
          else
            # Without parentheses, `must_equal {a: 1}` would be parsed as a block.
            corrector.replace(node.loc.selector.end.join(hash.source_range.begin), '({')
            corrector.insert_after(hash, '})')
          end
        end
      end
    end
  end
end
