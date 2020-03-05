# frozen_string_literal: true

require 'test_helper'

class AssertTruthyTest < Minitest::Test
  def test_registers_offense_when_using_assert_equal_with_true
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(true, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert(somestuff)` over `assert_equal(true, somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_true_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(true, somestuff, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert(somestuff, 'message')` over `assert_equal(true, somestuff, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_a_method_call
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(true, obj.is_something?, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert(obj.is_something?, 'message')` over `assert_equal(true, obj.is_something?, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.is_something?, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_true_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(true, obj.is_something?, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert(obj.is_something?, <<~MESSAGE)` over `assert_equal(true, obj.is_something?, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.is_something?, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_somethingra
          assert(somestuff)
        end
      end
    RUBY
  end
end
