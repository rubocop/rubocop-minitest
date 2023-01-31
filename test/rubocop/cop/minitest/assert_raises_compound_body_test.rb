# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertRaisesCompoundBodyTest < Minitest::Test
  def test_registers_offense_when_multi_statement_bodies
    assert_offense(<<~RUBY)
      assert_raises(MyError) do
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Reduce `assert_raises` block body to contain only the raising code.
        foo
        bar
      end
    RUBY
  end

  def test_does_not_register_offense_when_single_statement_bodies
    assert_no_offenses(<<~RUBY)
      assert_raises(MyError) do
        foo
      end
    RUBY
  end

  def test_does_not_register_offense_when_begin_rescue
    assert_no_offenses(<<~RUBY)
      assert_raises(MyError) do
        begin
          foo
          bar
        rescue
          baz
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_parenthesized_statement
    assert_no_offenses(<<~RUBY)
      assert_raises(MyError) do
        (foo)
      end
    RUBY
  end

  def test_does_not_register_offense_when_send_with_block_bodies
    assert_no_offenses(<<~RUBY)
      assert_raises(MyError) do
        foo do
          bar
          baz
        end
      end
    RUBY
  end
end
