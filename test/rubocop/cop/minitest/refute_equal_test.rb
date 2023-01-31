# frozen_string_literal: true

require_relative '../../../test_helper'

class RefuteEqualTest < Minitest::Test
  def test_registers_offense_when_using_assert_not_equal_operator_with_string
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert('rubocop-minitest' != actual)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_equal('rubocop-minitest', actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal('rubocop-minitest', actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_not_equal_operator_with_object
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(expected != actual)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_equal(expected, actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_not_equal_operator_with_method_call
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.expected != other_obj.actual)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_equal(obj.expected, other_obj.actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(obj.expected, other_obj.actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_not_equal_operator_with_the_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert('rubocop-minitest' != actual, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_equal('rubocop-minitest', actual, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal('rubocop-minitest', actual, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_negate_equals
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(! 'rubocop-minitest' == object)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_equal('rubocop-minitest', object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal('rubocop-minitest', object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_negate_equals_with_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(! 'rubocop-minitest' == object, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_equal('rubocop-minitest', object, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal('rubocop-minitest', object, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_operator_with_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(!'rubocop-minitest' == actual, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_equal('rubocop-minitest', actual, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal('rubocop-minitest', actual, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_equal
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal('rubocop-minitest', actual)
        end
      end
    RUBY
  end
end
