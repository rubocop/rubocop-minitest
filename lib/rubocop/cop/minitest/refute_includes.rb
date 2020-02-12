# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `refute_includes`
      # instead of using `refute(collection.include?(object))`.
      #
      # @example
      #   # bad
      #   refute(collection.include?(object))
      #   refute(collection.include?(object), 'the message')
      #
      #   # good
      #   refute_includes(collection, object)
      #   refute_includes(collection, object, 'the message')
      #
      class RefuteIncludes < Cop
        extend IncludesCopRule

        rule target_method: :refute, prefer_method: :refute_includes
      end
    end
  end
end
