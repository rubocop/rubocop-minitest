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
        extend MinitestCopRule

        rule :refute, target_method: :include?, prefer_method: :refute_includes
      end
    end
  end
end
