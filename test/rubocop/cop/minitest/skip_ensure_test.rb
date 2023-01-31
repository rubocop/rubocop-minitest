# frozen_string_literal: true

require_relative '../../../test_helper'

class SkipEnsureTest < Minitest::Test
  def test_registers_offense_when_using_skip_in_the_method_body
    assert_offense(<<~RUBY)
      def test_skip
        skip 'This test is skipped.'

        assert 'foo'.present?
      ensure
      ^^^^^^ `ensure` is called even though the test is skipped.
        do_something
      end
    RUBY
  end

  def test_registers_offense_when_not_using_skip_in_the_method_body
    assert_no_offenses(<<~RUBY)
      def test_skip
        skip 'This test is skipped.'

        begin
          assert 'foo'.present?
        ensure
          do_something
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_not_using_ensure
    assert_no_offenses(<<~RUBY)
      def test_skip
        skip 'This test is skipped.'

        assert 'foo'.present?

        do_something
      end
    RUBY
  end

  def test_does_not_register_offense_when_not_using_skip
    assert_no_offenses(<<~RUBY)
      def test_skip
        assert 'foo'.present?
      ensure
        do_something
      end
    RUBY
  end

  def test_registers_offense_when_using_skip_with_condition_but_the_condition_is_not_used_in_ensure
    assert_offense(<<~RUBY)
      def test_conditional_skip
        skip 'This test is skipped.' if condition

        assert do_something
      ensure
      ^^^^^^ `ensure` is called even though the test is skipped.
        do_teardown
      end
    RUBY
  end

  def test_registers_offense_when_using_skip_with_condition_and_the_condition_is_used_in_ensure
    assert_no_offenses(<<~RUBY)
      def test_conditional_skip
        skip 'This test is skipped.' if condition

        assert do_something
      ensure
        if condition
          do_teardown
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_skip_with_condition_and_the_condition_is_used_in_ensure_but_keyword_is_mismatch
    assert_offense(<<~RUBY)
      def test_conditional_skip
        skip 'This test is skipped.' if condition

        assert do_something
      ensure
      ^^^^^^ `ensure` is called even though the test is skipped.
        unless condition
          do_teardown
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_skip_in_rescue
    assert_no_offenses(<<~RUBY)
      def test_skip_is_used_in_rescue
        do_setup

        assert do_something
      rescue
        skip 'This test is skipped.'
      ensure
        do_teardown
      end
    RUBY
  end

  def test_registers_offense_when_using_skip_with_receiver
    assert_no_offenses(<<~RUBY)
      def test_skip_with_receiver
        obj.skip 'This test is skipped.'

        assert 'foo'.present?
      ensure
        do_something
      end
    RUBY
  end
end
