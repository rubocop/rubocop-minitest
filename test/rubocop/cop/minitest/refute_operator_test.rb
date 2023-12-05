# frozen_string_literal: true

require_relative '../../../test_helper'

class RefuteOperatorTest < RuboCop::Minitest::Test
  def test_registers_offense_when_using_refute_with_operator_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(expected < actual)
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_operator(expected, :<, actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_operator(expected, :<, actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_operator_method_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(expected < actual, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_operator(expected, :<, actual, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_operator(expected, :<, actual, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_operator_method_without_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute expected < actual
          ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_operator(expected, :<, actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_operator expected, :<, actual
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_not_refute_with_operator_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_operator(expected, :<, actual)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_variable
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          var = do_something

          refute(var)
        end
      end
    RUBY
  end

  def test_does_not_consider_brackets_to_be_an_offense
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(array_of_booleans[42])
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_unary_operation
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(-x)
        end
      end
    RUBY
  end
end
