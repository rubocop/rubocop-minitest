# frozen_string_literal: true

require 'test_helper'

class RefuteMatchTest < Minitest::Test
  def test_registers_offense_when_using_refute_with_match
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(matcher.match(object))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(matcher, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match(matcher, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_match_and_lhs_is_regexp_literal
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(/regexp/.match(object))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(/regexp/, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match(/regexp/, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_match_and_rhs_is_regexp_literal
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.match(/regexp/))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(/regexp/, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match(/regexp/, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_match_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(matcher.match(object), 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(matcher, object, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match(matcher, object, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_match_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(matcher.match(object), <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(matcher, object, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match(matcher, object, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_match_in_redundant_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute((matcher.match(string)))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(matcher, string)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match((matcher, string))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_match
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match(matcher, object)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_no_arguments_match_call
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(matcher.match)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_no_arguments_match_safe_navigation_call
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(matcher&.match)
        end
      end
    RUBY
  end
end
