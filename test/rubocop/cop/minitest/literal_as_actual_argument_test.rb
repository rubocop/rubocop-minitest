# frozen_string_literal: true

require 'test_helper'

class LiteralAsActualArgumentTest < Minitest::Test
  def test_registers_offense_when_actual_is_basic_literal
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(foo, 2)
                       ^^^^^^ Replace the literal with the first argument.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(2, foo)
        end
      end
    RUBY
  end

  def test_registers_offense_when_actual_is_recursive_basic_literal
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(foo, [1, 2, { key: :value }])
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Replace the literal with the first argument.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal([1, 2, { key: :value }], foo)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_actual_is_not_literal
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(foo, bar)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_only_expected_is_literal
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(2, foo)
        end
      end
    RUBY
  end
end
