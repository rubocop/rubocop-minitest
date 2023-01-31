# frozen_string_literal: true

require_relative '../../../test_helper'

class RefuteSameTest < Minitest::Test
  def test_registers_offense_when_using_equal
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(expected.equal?(actual))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_same(expected, actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_same(expected, actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_equal_with_method_call
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.expected.equal?(other_obj.actual))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_same(obj.expected, other_obj.actual)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_same(obj.expected, other_obj.actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_the_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(expected.equal?(actual), 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_same(expected, actual, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_same(expected, actual, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(expected.equal?(actual), <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_same(expected, actual, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_same(expected, actual, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_same
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_same(expected, actual)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_not_using_equal
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(expected.eql?(actual))
          refute(foo.combines?(bar))
        end
      end
    RUBY
  end
end
