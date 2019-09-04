# frozen_string_literal: true

require 'test_helper'

class AssertEmptyTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::AssertEmpty.new
  end

  def test_adds_offense_for_use_of_assert_with_empty
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff.empty?)
          ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff)` over `assert(somestuff.empty?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty(somestuff)
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_assert_with_empty_and_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff.empty?, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff, 'the message')` over `assert(somestuff.empty?, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty(somestuff, 'the message')
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_assert_with_empty_and_string_variable_in_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          assert(somestuff.empty?, message)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff, message)` over `assert(somestuff.empty?, message)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          assert_empty(somestuff, message)
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_assert_with_empty_and_a_constant_in_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          assert(somestuff.empty?, MESSAGE)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff, MESSAGE)` over `assert(somestuff.empty?, MESSAGE)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          assert_empty(somestuff, MESSAGE)
        end
      end
    RUBY
  end

  def test_does_not_offend_if_using_assert_empty
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty(somestuff)
        end
      end
    RUBY
  end
end
