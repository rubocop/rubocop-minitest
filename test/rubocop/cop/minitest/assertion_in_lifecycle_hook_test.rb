# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertionInLifecycleHookTest < Minitest::Test
  def test_registers_offense_when_using_bad_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def setup
          assert_equal(foo, bar)
          ^^^^^^^^^^^^^^^^^^^^^^ Do not use `assert_equal` in `setup` hook.
        end
      end
    RUBY
  end

  def test_checks_only_test_classes
    assert_no_offenses(<<~RUBY)
      class Foo
        def setup
          assert_equal(foo, bar)
        end
      end
    RUBY
  end

  def test_checks_only_hooks
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(foo, bar)
        end
      end
    RUBY
  end
end
