# frozen_string_literal: true

require 'test_helper'

class EmptyHookTest < Minitest::Test
  def test_registers_offense_when_empty_hook
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def setup
          setup_something
        end

        def setup
        ^^^^^^^^^ Empty hook detected.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def setup
          setup_something
        end

        
      end
    RUBY
  end

  def test_checks_only_minitest_test_children
    assert_no_offenses(<<~RUBY)
      class FooTest
        def setup
        end
      end
    RUBY
  end

  def test_checks_only_hooks
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
        end
      end
    RUBY
  end
end
