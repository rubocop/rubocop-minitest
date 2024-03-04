# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertSilentTest < RuboCop::Minitest::Test
  def test_registers_offense_when_using_assert_output_with_empty_strings
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_output("", "") do
          ^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_silent`.
            puts object.do_something
          end
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_silent do
            puts object.do_something
          end
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_output_with_non_empty_strings
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_output("something", "") do
            puts object.do_something
          end
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_silence_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_silent do
            puts object.do_something
          end
        end
      end
    RUBY
  end
end
