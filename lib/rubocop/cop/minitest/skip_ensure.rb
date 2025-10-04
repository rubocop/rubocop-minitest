# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Checks that code in an `ensure` block does not run when the test is skipped.
      # If `skip` is conditional, the `ensure` block must also be conditional,
      # using the negation of the skip condition so that it runs only when the test runs.
      #
      # On the other hand, `skip` used inside a `rescue` clause is accepted,
      # because the `ensure` block may serve as teardown for resources created in the `begin` setup.
      #
      # @example
      #
      #   # bad
      #   def test_skip
      #     skip 'This test is skipped.'
      #
      #     assert 'foo'.present?
      #   ensure
      #     do_something
      #   end
      #
      #   # bad
      #   def test_conditional_skip
      #     skip 'This test is skipped.' if condition
      #
      #     assert do_something
      #   ensure
      #     do_teardown
      #   end
      #
      #   # good
      #   def test_skip
      #     skip 'This test is skipped.'
      #
      #     begin
      #       assert 'foo'.present?
      #     ensure
      #       do_something
      #     end
      #   end
      #
      #   # good
      #   def test_conditional_skip
      #     skip 'This test is skipped.' if condition
      #
      #     assert do_something
      #   ensure
      #     unless condition
      #       do_teardown
      #     end
      #   end
      #
      #   # good
      #   def test_skip_is_used_in_rescue
      #     do_setup
      #     assert do_something
      #   rescue
      #     skip 'This test is skipped.'
      #   ensure
      #     do_teardown
      #   end
      #
      class SkipEnsure < Base
        MSG = '`ensure` is called even though the test is skipped.'

        def on_ensure(node)
          skip = find_skip(node)

          return if skip.nil? || use_skip_in_rescue?(skip) || valid_conditional_skip?(skip, node)

          add_offense(node.loc.keyword)
        end

        private

        def find_skip(node)
          return unless (body = node.node_parts.first)

          body.descendants.detect { |n| n.send_type? && n.receiver.nil? && n.method?(:skip) }
        end

        def use_skip_in_rescue?(skip_method)
          skip_method.ancestors.detect(&:rescue_type?)
        end

        def valid_conditional_skip?(skip_method, ensure_node)
          if_node = skip_method.ancestors.detect(&:if_type?)
          return false unless ensure_node.branch.if_type?

          match_keyword = ensure_node.branch.if? ? if_node.if? : if_node.unless?
          match_keyword && ensure_node.branch.condition == if_node.condition
        end
      end
    end
  end
end
