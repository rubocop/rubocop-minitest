# frozen_string_literal: true

require 'test_helper'

class AssertRaisesWithRegexpArgumentTest < Minitest::Test
  def test_registers_offense_with_regexp
    assert_offense(<<~RUBY)
      assert_raises(MyError, /some message/) do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not pass regular expression literals to `assert_raises`. Test the resulting exception.
        foo
      end
    RUBY
  end

  def test_does_not_register_offense_with_other_args
    assert_no_offenses(<<~RUBY)
      assert_raises(MyError, SomeOtherError, some_local_var) do
        foo
      end
    RUBY
  end

  def test_does_not_register_offense_with_single_arg
    assert_no_offenses(<<~RUBY)
      assert_raises(MyError) do
        foo
      end
    RUBY
  end
end
