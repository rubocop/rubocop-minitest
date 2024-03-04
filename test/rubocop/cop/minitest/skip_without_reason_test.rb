# frozen_string_literal: true

require_relative '../../../test_helper'

class SkipWithoutReasonTest < RuboCop::Minitest::Test
  def test_registers_offense_when_skip_without_reason
    assert_offense(<<~RUBY)
      skip
      ^^^^ Add a reason explaining why the test is skipped.
    RUBY
  end

  def test_registers_offense_when_skip_with_empty_reason
    assert_offense(<<~RUBY)
      skip('')
      ^^^^^^^^ Add a reason explaining why the test is skipped.
    RUBY
  end

  def test_does_not_register_offense_when_skip_with_string_reason
    assert_no_offenses(<<~RUBY)
      skip('Reason')
    RUBY
  end

  def test_does_not_register_offense_when_skip_with_dynamic_reason
    assert_no_offenses(<<~RUBY)
      skip(reason)
    RUBY
  end

  def test_registers_offense_when_skip_within_loop
    assert_offense(<<~RUBY)
      skip while condition?
      ^^^^ Add a reason explaining why the test is skipped.
    RUBY
  end

  def test_does_not_register_offense_when_skip_within_conditional
    assert_no_offenses(<<~RUBY)
      skip if condition?

      case
      when condition?
        skip
      else
        do_something
      end

      case
      when condition?
        do_something
      else
        skip
      end
    RUBY
  end

  def test_registers_offense_when_skip_within_complex_body_of_conditional
    assert_offense(<<~RUBY)
      if condition?
        do_something
        skip
        ^^^^ Add a reason explaining why the test is skipped.
      end

      case
      when condition?
        do_something
        skip
        ^^^^ Add a reason explaining why the test is skipped.
      end

      case
      when condition?
      else
        do_something
        skip
        ^^^^ Add a reason explaining why the test is skipped.
      end
    RUBY
  end

  def test_registers_offense_when_conditional_branches_contains_only_skip
    assert_offense(<<~RUBY)
      if condition?
        skip
        ^^^^ Add a reason explaining why the test is skipped.
      else
        skip
        ^^^^ Add a reason explaining why the test is skipped.
      end

      case
      when condition?
        skip
        ^^^^ Add a reason explaining why the test is skipped.
      else
        skip
        ^^^^ Add a reason explaining why the test is skipped.
      end
    RUBY
  end

  def test_does_not_register_offense_when_skip_within_rescue
    assert_no_offenses(<<~RUBY)
      begin
        do_something
      rescue ArgumentError
        skip
      end
    RUBY
  end

  def test_does_not_register_offense_when_calling_skip_on_object
    assert_no_offenses(<<~RUBY)
      object.skip
    RUBY
  end
end
