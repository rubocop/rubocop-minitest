# frozen_string_literal: true

require 'test_helper'

class AssertMatchTest < Minitest::Test
  def test_registers_offense_when_using_assert_with_match
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(matcher.match(object))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_match(matcher, object)` over `assert(matcher.match(object))`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(matcher, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_match_and_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert(matcher.match(object), 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_match(matcher, object, 'the message')` over `assert(matcher.match(object), 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(matcher, object, 'the message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_match_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(matcher.match(object), <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_match(matcher, object, <<~MESSAGE)` over `assert(matcher.match(object), <<~MESSAGE)`.
            the message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(matcher, object, <<~MESSAGE
            the message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_match
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(matcher, object)
        end
      end
    RUBY
  end
end
