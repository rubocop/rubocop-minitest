# frozen_string_literal: true

require 'test_helper'

class RefuteFalseTest < Minitest::Test
  def test_registers_offense_when_using_assert_equal_with_false
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(false, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(somestuff)` over `assert_equal(false, somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_false_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(false, somestuff, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(somestuff, 'message')` over `assert_equal(false, somestuff, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_method_call
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(false, obj.do_something, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(obj.do_something, 'message')` over `assert_equal(false, obj.do_something, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.do_something, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_false_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(false, obj.do_something, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(obj.do_something, <<~MESSAGE)` over `assert_equal(false, obj.do_something, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.do_something, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_test_condition
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(!test)
          ^^^^^^^^^^^^^ Prefer using `refute(test)` over `assert(!test)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(test)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_bang_test_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(!test, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(test, 'message')` over `assert(!test, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(test, 'message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff)
        end
      end
    RUBY
  end
end
