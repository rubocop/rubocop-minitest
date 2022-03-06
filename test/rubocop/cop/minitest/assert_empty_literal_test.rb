# frozen_string_literal: true

require 'test_helper'

class AssertEmptyLiteralTest < Minitest::Test
  def test_registers_offense_when_asserting_empty_array
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal([], somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff)`.
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
          assert_equal({}, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff)`.
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

  def test_does_not_register_offense_when_asserting_non_empty_array
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(['somestuff'], somestuff)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_asserting_two_parameters
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(somestuff, someotherstuff)
        end
      end
    RUBY
  end
end
