# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Checks for deprecated global expectations
      # and autocorrects them to use expect format.
      #
      # @example EnforcedStyle: any (default)
      #   # bad
      #   musts.must_equal expected_musts
      #   wonts.wont_match expected_wonts
      #   musts.must_raise TypeError
      #
      #   # good
      #   _(musts).must_equal expected_musts
      #   _(wonts).wont_match expected_wonts
      #   _ { musts }.must_raise TypeError
      #
      #   expect(musts).must_equal expected_musts
      #   expect(wonts).wont_match expected_wonts
      #   expect { musts }.must_raise TypeError
      #
      #   value(musts).must_equal expected_musts
      #   value(wonts).wont_match expected_wonts
      #   value { musts }.must_raise TypeError
      #
      # @example EnforcedStyle: _
      #   # bad
      #   musts.must_equal expected_musts
      #   wonts.wont_match expected_wonts
      #   musts.must_raise TypeError
      #
      #   expect(musts).must_equal expected_musts
      #   expect(wonts).wont_match expected_wonts
      #   expect { musts }.must_raise TypeError
      #
      #   value(musts).must_equal expected_musts
      #   value(wonts).wont_match expected_wonts
      #   value { musts }.must_raise TypeError
      #
      #   # good
      #   _(musts).must_equal expected_musts
      #   _(wonts).wont_match expected_wonts
      #   _ { musts }.must_raise TypeError
      #
      # @example EnforcedStyle: expect
      #   # bad
      #   musts.must_equal expected_musts
      #   wonts.wont_match expected_wonts
      #   musts.must_raise TypeError
      #
      #   _(musts).must_equal expected_musts
      #   _(wonts).wont_match expected_wonts
      #   _ { musts }.must_raise TypeError
      #
      #   value(musts).must_equal expected_musts
      #   value(wonts).wont_match expected_wonts
      #   value { musts }.must_raise TypeError
      #
      #   # good
      #   expect(musts).must_equal expected_musts
      #   expect(wonts).wont_match expected_wonts
      #   expect { musts }.must_raise TypeError
      #
      # @example EnforcedStyle: value
      #   # bad
      #   musts.must_equal expected_musts
      #   wonts.wont_match expected_wonts
      #   musts.must_raise TypeError
      #
      #   _(musts).must_equal expected_musts
      #   _(wonts).wont_match expected_wonts
      #   _ { musts }.must_raise TypeError
      #
      #   expect(musts).must_equal expected_musts
      #   expect(wonts).wont_match expected_wonts
      #   expect { musts }.must_raise TypeError
      #
      #   # good
      #   value(musts).must_equal expected_musts
      #   value(wonts).wont_match expected_wonts
      #   value { musts }.must_raise TypeError
      class GlobalExpectations < Base
        include ConfigurableEnforcedStyle
        extend AutoCorrector

        MSG = 'Use `%<preferred>s` instead.'

        VALUE_MATCHERS = MinitestExplorationHelpers::VALUE_MATCHERS
        BLOCK_MATCHERS = MinitestExplorationHelpers::BLOCK_MATCHERS

        RESTRICT_ON_SEND = MinitestExplorationHelpers::MATCHER_METHODS

        # There are aliases for the `_` method - `expect` and `value`
        DSL_METHODS = %i[_ expect value].freeze

        def on_send(node)
          receiver = node.receiver
          return unless receiver

          method = block_receiver?(receiver) || value_receiver?(receiver)
          return if method == preferred_method || (method && style == :any)

          register_offense(node, method)
        end

        private

        def_node_matcher :block_receiver?, <<~PATTERN
          (block (send nil? $#method_allowed?) _ _)
        PATTERN

        def_node_matcher :value_receiver?, <<~PATTERN
          (send nil? $#method_allowed? _)
        PATTERN

        def method_allowed?(method)
          DSL_METHODS.include?(method)
        end

        def preferred_method
          style == :any ? :_ : style
        end

        def preferred_receiver(node)
          receiver = node.receiver

          if BLOCK_MATCHERS.include?(node.method_name)
            body = receiver.lambda? ? receiver.body : receiver
            "#{preferred_method} { #{body.source} }"
          else
            "#{preferred_method}(#{receiver.source})"
          end
        end

        def register_offense(node, method)
          receiver = node.receiver
          preferred = method ? preferred_method : preferred_receiver(node)
          message = format(MSG, preferred: preferred)

          add_offense(receiver, message: message) do |corrector|
            autocorrect(corrector, node, receiver, method)
          end
        end

        # Replacing the whole receiver would overlap the correction of a matcher call nested
        # in that receiver (`a.must_equal(b).must_equal(c)`), so only the DSL method selector
        # is replaced and new DSL calls are wrapped around the receiver instead.
        def autocorrect(corrector, node, receiver, method)
          if method
            corrector.replace(dsl_method_selector(receiver), preferred_method.to_s)
          elsif BLOCK_MATCHERS.include?(node.method_name)
            autocorrect_block_matcher(corrector, receiver)
          else
            corrector.wrap(receiver, "#{preferred_method}(", ')')
          end
        end

        def dsl_method_selector(receiver)
          receiver.block_type? ? receiver.send_node.loc.selector : receiver.loc.selector
        end

        def autocorrect_block_matcher(corrector, receiver)
          if receiver.block_type? && receiver.lambda?
            corrector.replace(receiver, "#{preferred_method} { #{receiver.body.source} }")
          else
            corrector.wrap(receiver, "#{preferred_method} { ", ' }')
          end
        end
      end
    end
  end
end
