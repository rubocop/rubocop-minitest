# frozen_string_literal: true

require 'test_helper'

class RefuteFalseTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::RefuteFalse.new
  end

  def test_registers_offense_when_using_assert_equal_with_false
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(false, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(somestuff)` over `assert_equal(false, somestuff)`.
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

  def test_registers_offense_when_using_assert_equal_with_false_and_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(false, somestuff, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(somestuff, 'the message')` over `assert_equal(false, somestuff, 'the message')`.
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

  def test_registers_offense_when_using_assert_equal_with_method_call
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(false, obj.do_something, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(obj.do_something, 'the message')` over `assert_equal(false, obj.do_something, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.do_something, 'the message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_false_and_heredoc_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(false, obj.do_something, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute(obj.do_something, <<~MESSAGE)` over `assert_equal(false, obj.do_something, <<~MESSAGE)`.
            the message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.do_something, <<~MESSAGE
            the message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_method
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff)
        end
      end
    RUBY
  end
end
