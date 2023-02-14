# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Enforces the test to use `assert_instance_of(Class, object)`
      # over `assert_equal(Class, object.class)`.
      #
      # @example
      #   # bad
      #   assert_equal(Class, object.class)
      #   assert_equal(Class, object.class, 'message')
      #
      #   # good
      #   assert_instance_of(Class, object)
      #   assert_instance_of(Class, object, 'message')
      #
      class AssertEqualClass < Base
        # extend MinitestCopRule
        # define_rule :assert_equal, target_method: :class, preferred_method: :assert_instance_of, inverse: true

        extend AutoCorrector
        include RangeHelp

        MSG = 'Prefer using `assert_instance_of(%<arguments>s)`.'
        RESTRICT_ON_SEND = [:assert_equal].freeze

        def_node_matcher :assert_equal_class, <<~PATTERN
          (send _ :assert_equal $_ $(send $_ :class) $...)
        PATTERN

        def on_send(node)
          assert_equal_class(node) do |klass, class_send, instance, rest_args|
            add_offense(node, message: message(klass, instance, rest_args)) do |corrector|
              dot_class_range = range_between(class_send.loc.dot.begin_pos, class_send.loc.selector.end_pos)
              corrector.replace(node.loc.selector, 'assert_instance_of')
              corrector.remove(dot_class_range)
            end
          end
        end

        private

        def message(klass, instance, rest_args)
          format(MSG, arguments: [klass.source, instance.source, *rest_args.map(&:source)].join(', '))
        end
      end
    end
  end
end
