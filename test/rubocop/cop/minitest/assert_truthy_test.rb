# frozen_string_literal: true

require 'test_helper'

class AssertTruthyTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::AssertTruthy.new
  end

  def test_registers_offense_when_using_assert_equal_with_true
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(true, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert(somestuff)` over `assert_equal(true, somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_true_and_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(true, somestuff, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert(somestuff, 'the message')` over `assert_equal(true, somestuff, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff, 'the message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_a_method_call
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(true, obj.is_something?, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert(obj.is_something?, 'the message')` over `assert_equal(true, obj.is_something?, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.is_something?, 'the message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_variable_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          assert_equal(true, somestuff, message)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert(somestuff, message)` over `assert_equal(true, somestuff, message)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          assert(somestuff, message)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_constant_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          assert_equal(true, somestuff, MESSAGE)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert(somestuff, MESSAGE)` over `assert_equal(true, somestuff, MESSAGE)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          assert(somestuff, MESSAGE)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_method
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_somethingra
          assert(somestuff)
        end
      end
    RUBY
  end

  # Refute
  def test_adds_offense_for_use_of_refute_equal_true
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(true, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(somestuff)` over `refute_equal(true, somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff)
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_refute_equal_true_with_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(true, somestuff, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(somestuff, 'the message')` over `refute_equal(true, somestuff, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff, 'the message')
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_refute_equal_with_a_method_call
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(true, obj.is_something?, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(obj.is_something?, 'the message')` over `refute_equal(true, obj.is_something?, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.is_something?, 'the message')
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_refute_equal_with_a_string_variable_in_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          refute_equal(true, somestuff, message)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(somestuff, message)` over `refute_equal(true, somestuff, message)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          refute(somestuff, message)
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_refute_equal_with_a_constant_in_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          refute_equal(true, somestuff, MESSAGE)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(somestuff, MESSAGE)` over `refute_equal(true, somestuff, MESSAGE)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          refute(somestuff, MESSAGE)
        end
      end
    RUBY
  end

  def test_does_not_offend_if_using_refute
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_somethingra
          refute(somestuff)
        end
      end
    RUBY
  end
end
