# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertEqualTest < Minitest::Test
  def test_registers_offense_when_using_assert_equal_operator_with_string
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert('rubocop-minitest' == actual)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_equal('rubocop-minitest', actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal('rubocop-minitest', actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_operator_with_object
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(expected == actual)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_equal(expected, actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_operator_with_method_call
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.expected == other_obj.actual)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_equal(obj.expected, other_obj.actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(obj.expected, other_obj.actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_operator_with_the_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert('rubocop-minitest' == actual, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_equal('rubocop-minitest', actual, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal('rubocop-minitest', actual, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_operator_with_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert('rubocop-minitest' == actual, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_equal('rubocop-minitest', actual, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal('rubocop-minitest', actual, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_operator_with_equal_symbol_argument
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_operator('rubocop-minitest', :==, actual)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_equal('rubocop-minitest', actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal('rubocop-minitest', actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_operator_with_equal_symbol_and_message_argument
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_operator('rubocop-minitest', :==, actual, message)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_equal('rubocop-minitest', actual, message)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal('rubocop-minitest', actual, message)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_equal
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal('rubocop-minitest', actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_operator_with_negated_equal_symbol_argument
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_operator('rubocop-minitest', :!=, actual)
        end
      end
    RUBY
  end

  # Redundant parentheses should be removed by `Style/RedundantParentheses` cop.
  def test_does_not_register_offense_when_using_assert_with_equal_in_redundant_parentheses
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(('rubocop-minitest' == actual))
        end
      end
    RUBY
  end

  # See: https://github.com/rubocop/rubocop-minitest/issues/113
  def test_does_not_register_offense_when_assert_with_block_argument
    assert_no_offenses(<<~RUBY)
      assert { 1 + 2 == 3 }
    RUBY
  end
end
