# frozen_string_literal: true

require_relative '../../../test_helper'

class RefuteRespondToTest < RuboCop::Minitest::Test
  def test_registers_offense_when_using_refute_calling_respond_to_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.respond_to?(:do_something))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_respond_to(object, :do_something)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_respond_to(object, :do_something)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_calling_respond_to_method_with_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.respond_to?(:do_something), 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_respond_to(object, :do_something, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_respond_to(object, :do_something, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_calling_respond_to_with_receiver_omitted
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(respond_to?(:do_something))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_respond_to(self, :do_something)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_respond_to(self, :do_something)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_calling_respond_to_method_with_heredoc_msg
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(respond_to?(:do_something), <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_respond_to(self, :do_something, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_respond_to(self, :do_something, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  # Redundant parentheses should be removed by `Style/RedundantParentheses` cop.
  def test_does_not_register_offense_when_using_refute_with_respond_to_in_redundant_parentheses
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute((object.respond_to?(:do_something)))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_respond_to
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_respond_to('rubocop-minitest', :do_something)
        end
      end
    RUBY
  end
end
