# frozen_string_literal: true

require 'test_helper'

class UnreachableAssertionTest < Minitest::Test
  def test_registers_offense_when_using_assert_equal_at_bottom_of_assert_raises_block
    assert_offense(<<~RUBY)
      assert_raises FooError do
        obj.foo
        assert_equal('foo', obj.bar)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Unreachable `assert_equal` detected.
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_empty_at_bottom_of_assert_raises_block
    assert_offense(<<~RUBY)
      assert_raises FooError do
        obj.foo
        assert_empty(obj.bar)
        ^^^^^^^^^^^^^^^^^^^^^ Unreachable `assert_empty` detected.
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_equal_at_top_of_assert_raises_block
    assert_no_offenses(<<~RUBY)
      assert_raises FooError do
        assert_equal('foo', obj.bar)
        obj.foo
      end
    RUBY
  end

  def test_does_not_register_offense_when_not_using_assertion_method_in_assert_raises_block
    assert_no_offenses(<<~RUBY)
      assert_raises FooError do
        do_something('foo', obj.bar)
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_empty_block_for_assert_raises
    assert_no_offenses(<<~RUBY)
      assert_raises FooError do
      end
    RUBY
  end

  def test_does_not_register_offense_when_not_using_assert_equal_at_bottom_of_non_assert_raises_block
    assert_no_offenses(<<~RUBY)
      do_something do
        obj.foo
        assert_empty(obj.bar)
      end
    RUBY
  end
end
