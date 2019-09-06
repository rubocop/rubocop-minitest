# frozen_string_literal: true

require 'test_helper'

class RefuteNilTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::RefuteNil.new
  end

  def test_adds_offense_for_use_of_refute_equal_nil
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff)` over `refute_equal(nil, somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff)
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_refute_equal_nil_with_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, somestuff, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff, 'the message')` over `refute_equal(nil, somestuff, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff, 'the message')
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_refute_equal_with_a_method_call
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, obj.do_something, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(obj.do_something, 'the message')` over `refute_equal(nil, obj.do_something, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(obj.do_something, 'the message')
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_refute_equal_with_a_string_variable_in_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          refute_equal(nil, somestuff, message)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff, message)` over `refute_equal(nil, somestuff, message)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          message = 'the message'
          refute_nil(somestuff, message)
        end
      end
    RUBY
  end

  def test_adds_offense_for_use_of_refute_equal_with_a_constant_in_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          refute_equal(nil, somestuff, MESSAGE)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff, MESSAGE)` over `refute_equal(nil, somestuff, MESSAGE)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        MESSAGE = 'the message'

        def test_do_something
          refute_nil(somestuff, MESSAGE)
        end
      end
    RUBY
  end

  def test_does_not_offend_if_using_refute_nil
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff)
        end
      end
    RUBY
  end
end
