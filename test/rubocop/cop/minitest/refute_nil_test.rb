# frozen_string_literal: true

require 'test_helper'

class RefuteNilTest < Minitest::Test
  def test_registers_offense_when_using_refute_equal_with_nil
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, somestuff)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_nil_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, somestuff, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_a_method_call
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, obj.do_something, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(obj.do_something, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(obj.do_something, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_nil_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(nil, obj.do_something, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(obj.do_something, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(obj.do_something, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_nil_predicate_method_call
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff.nil?)
          ^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_nil_predicate_method_call_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff.nil?, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(somestuff, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_predicate
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_predicate(object, :nil?)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_predicate_with_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_predicate(object, :nil?, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_nil(object, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(object, 'message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_nil_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_nil(somestuff)
        end
      end
    RUBY
  end
end
