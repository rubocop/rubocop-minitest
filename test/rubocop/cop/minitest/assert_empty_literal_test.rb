# frozen_string_literal: true

require 'test_helper'

class AssertEmptyLiteralTest < Minitest::Test
  def test_registers_offense_when_asserting_empty_array
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert([], somestuff)
          ^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff)` over `assert([], somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_asserting_empty_hash
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert({}, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff)` over `assert({}, somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty(somestuff)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_equal
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(['somestuff'], somestuff)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_with_single_parameter
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff)
        end
      end
    RUBY
  end
end
