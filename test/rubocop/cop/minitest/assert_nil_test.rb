# frozen_string_literal: true

require 'test_helper'

class AssertNilTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::AssertNil.new
  end

  def test_registers_offense_when_using_assert_equal_with_nil
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

  def test_registers_offense_when_using_assert_equal_with_nil_and_message
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

  def test_registers_offense_when_using_assert_equal_with_a_method_call
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

  def test_registers_offense_when_using_assert_equal_with_nil_and_heredoc_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(nil, obj.do_something, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(obj.do_something, <<~MESSAGE)` over `assert_equal(nil, obj.do_something, <<~MESSAGE)`.
            the message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(obj.do_something, <<~MESSAGE
            the message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_nil_method
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(somestuff)
        end
      end
    RUBY
  end
end
