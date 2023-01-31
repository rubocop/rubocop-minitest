# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertInDeltaTest < Minitest::Test
  def test_registers_offense_when_using_assert_equal_with_float_as_expected_value
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(0.2, foo)
          ^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_in_delta(0.2, foo)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_in_delta(0.2, foo)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_float_as_actual_value
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(foo, 0.2)
          ^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_in_delta(foo, 0.2)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_in_delta(foo, 0.2)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_float_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(0.2, foo, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_in_delta(0.2, foo, 0.001, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_in_delta(0.2, foo, 0.001, 'message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_equal_with_floats
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal foo, bar
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_in_delta_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_in_delta(foo, 0.2)
        end
      end
    RUBY
  end
end
