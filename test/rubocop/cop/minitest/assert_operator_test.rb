# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertOperatorTest < Minitest::Test
  def test_registers_offense_when_using_assert_with_operator_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(expected < actual)
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_operator(expected, :<, actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_operator(expected, :<, actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_operator_method_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(expected < actual, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_operator(expected, :<, actual, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_operator(expected, :<, actual, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_operator_method_without_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert expected < actual
          ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_operator(expected, :<, actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_operator expected, :<, actual
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_not_assert_with_operator_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_operator(expected, :<, actual)
        end
      end
    RUBY
  end
end
