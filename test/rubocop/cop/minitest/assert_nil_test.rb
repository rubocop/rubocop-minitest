# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertNilTest < RuboCop::Minitest::Test
  def test_registers_offense_when_using_assert_equal_with_nil
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(nil, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_nil_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(nil, somestuff, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(somestuff, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_a_method_call
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(nil, obj.do_something, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(obj.do_something, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(obj.do_something, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_equal_with_nil_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(nil, obj.do_something, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(obj.do_something, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(obj.do_something, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_nil_predicate_method_call
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff.nil?)
          ^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_nil_predicate_method_call_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff.nil?, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(somestuff, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_predicate
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_predicate(object, :nil?)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_predicate_with_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_predicate(object, :nil?, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(object, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(object, 'message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_nil_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_nil(somestuff)
        end
      end
    RUBY
  end
end
