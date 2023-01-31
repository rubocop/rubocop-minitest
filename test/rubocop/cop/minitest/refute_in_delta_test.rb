# frozen_string_literal: true

require_relative '../../../test_helper'

class RefuteInDeltaTest < Minitest::Test
  def test_registers_offense_when_using_refute_equal_with_float_as_expected_value
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(0.2, foo)
          ^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_in_delta(0.2, foo)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_in_delta(0.2, foo)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_float_as_actual_value
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(foo, 0.2)
          ^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_in_delta(foo, 0.2)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_in_delta(foo, 0.2)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_float_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(0.2, foo, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_in_delta(0.2, foo, 0.001, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_in_delta(0.2, foo, 0.001, 'message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_equal_with_floats
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal foo, bar
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_in_delta_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_in_delta(foo, 0.2)
        end
      end
    RUBY
  end
end
