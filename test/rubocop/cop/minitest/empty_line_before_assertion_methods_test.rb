# frozen_string_literal: true

require 'test_helper'

class EmptyLineBeforeAssertionMethodsTest < Minitest::Test
  def test_registers_offense_when_using_method_call_before_assertion_method
    assert_offense(<<~RUBY)
      def test_do_something
        do_something
        assert_equal(expected, actual)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add empty line before assertion.
      end
    RUBY

    assert_correction(<<~RUBY)
      def test_do_something
        do_something

        assert_equal(expected, actual)
      end
    RUBY
  end

  def test_registers_offense_when_using_method_call_with_line_breaked_args_before_assertion_method
    assert_offense(<<~RUBY)
      def test_do_something
        do_something(
          foo,
          bar
        )
        assert_equal(expected, actual)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add empty line before assertion.
      end
    RUBY

    assert_correction(<<~RUBY)
      def test_do_something
        do_something(
          foo,
          bar
        )

        assert_equal(expected, actual)
      end
    RUBY
  end

  def test_registers_offense_when_using_heredoc_before_assertion_method
    assert_offense(<<~RUBY)
      def test_do_something
        <<~EOS
          text
        EOS
        assert_equal(expected, actual)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add empty line before assertion.
      end
    RUBY

    assert_correction(<<~RUBY)
      def test_do_something
        <<~EOS
          text
        EOS

        assert_equal(expected, actual)
      end
    RUBY
  end

  def test_registers_offense_when_using_method_call_with_heredoc_arg_before_assertion_method
    assert_offense(<<~RUBY)
      def test_do_something
        do_something(<<~EOS)
          text
        EOS
        assert_equal(expected, actual)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add empty line before assertion.
      end
    RUBY

    assert_correction(<<~RUBY)
      def test_do_something
        do_something(<<~EOS)
          text
        EOS

        assert_equal(expected, actual)
      end
    RUBY
  end

  def test_registers_offense_when_using_method_call_with_block_arg_before_assertion_method
    assert_offense(<<~RUBY)
      def test_do_something
        block = -> { raise CustomError, 'This is really bad' }
        error = assert_raises(CustomError, &block)
        assert_equal 'This is really bad', error.message
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add empty line before assertion.
      end
    RUBY

    assert_correction(<<~RUBY)
      def test_do_something
        block = -> { raise CustomError, 'This is really bad' }
        error = assert_raises(CustomError, &block)

        assert_equal 'This is really bad', error.message
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_empty_line_before_assertion_methods
    assert_no_offenses(<<~RUBY)
      def test_do_something
        do_something

        assert_equal(expected, actual)
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assertion_method_at_top_level
    assert_no_offenses(<<~RUBY)
      assert_equal(expected, actual)
    RUBY
  end

  def test_does_not_register_offense_when_using_assertion_method_at_top_of_block_body
    assert_no_offenses(<<~RUBY)
      def test_do_something
        do_something do
          assert_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assertion_method_at_top_of_if_body
    assert_no_offenses(<<~RUBY)
      def test_do_something
        if condition
          assert_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assertion_method_at_top_of_while_body
    assert_no_offenses(<<~RUBY)
      def test_do_something
        while condition
          assert_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assertion_method_at_top_of_until_body
    assert_no_offenses(<<~RUBY)
      def test_do_something
        until condition
          assert_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assertion_methods_which_are_continuous_without_empty_line
    assert_no_offenses(<<~RUBY)
      def test_do_something
        assert_not foo
        assert bar
      end
    RUBY
  end
end
