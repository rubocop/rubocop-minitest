# frozen_string_literal: true

require 'rubocop'
require 'minitest'
require_relative 'minitest/assert_offense'

module RuboCop
  # Base test case class for testing custom cops with Minitest.
  #
  # @example Usage
  #
  #   class MyCopTest < RuboCop::TestCase
  #     def test_registers_offense
  #       assert_offense(<<~RUBY)
  #         bad_method
  #         ^^^^^^^^^^ Use `good_method` instead of `bad_method`.
  #       RUBY
  #
  #       assert_correction(<<~RUBY)
  #         good_method
  #       RUBY
  #     end
  #   end
  #
  # See the documentation of `RuboCop::Minitest::AssertOffense` for details.
  class TestCase < ::Minitest::Test
    include RuboCop::Minitest::AssertOffense
  end
end
