# frozen_string_literal: true

require 'test_helper'

class AssertNilTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::AssertNil.new
  end

  def test_adds_offense_for_use_of_assert_equal_nil
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(nil, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)` over `assert_equal(nil, somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(somestuff)
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_assert_equal_nil_with_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(nil, somestuff, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff, 'the message')` over `assert_equal(nil, somestuff, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(somestuff, 'the message')
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_assert_equal_with_a_method_call
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(nil, obj.do_something, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(obj.do_something, 'the message')` over `assert_equal(nil, obj.do_something, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(obj.do_something, 'the message')
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_assert_equal_with_a_string_variable_in_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          assert_equal(nil, somestuff, message)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff, message)` over `assert_equal(nil, somestuff, message)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          assert_nil(somestuff, message)
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_assert_equal_with_a_constant_in_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          assert_equal(nil, somestuff, MESSAGE)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff, MESSAGE)` over `assert_equal(nil, somestuff, MESSAGE)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          assert_nil(somestuff, MESSAGE)
        end
      end
    RUBY
  end

  def test_does_not_offend_if_using_assert_nil
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(somestuff)
        end
      end
    RUBY
  end
end
