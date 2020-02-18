# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `assert_includes`
      # instead of using `assert(collection.include?(object))`.
      #
      # @example
      #   # bad
      #   assert(collection.include?(object))
      #   assert(collection.include?(object), 'the message')
      #
      #   # good
      #   assert_includes(collection, object)
      #   assert_includes(collection, object, 'the message')
      #
      class AssertIncludes < Cop
        extend IncludesCopRule

        rule target_method: :assert, prefer_method: :assert_includes
      end
    end
  end
end
