# frozen_string_literal: true

require 'test_helper'

class OverridenHookTest < Minitest::Test
  def test_registers_offense_when_using_multiple_hooks_of_the_same_type
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def setup
        end

        def setup
            ^^^^^ This `:setup` hook overrides previously defined `:setup` hook.
        end
      end
    RUBY
  end

  def test_checks_only_minitest_test_children
    assert_no_offenses(<<~RUBY)
      class FooTest
        def setup
        end

        def setup
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_single_hook_of_type
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def setup
        end

        def teardown
        end
      end
    RUBY
  end
end
