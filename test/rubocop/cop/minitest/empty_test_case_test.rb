# frozen_string_literal: true

require 'test_helper'

class EmptyTestCaseTest < Minitest::Test
  def test_registers_offense_when_empty_test_case
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(foo, bar)
        end

        def test_empty
        ^^^^^^^^^^^^^^ Empty test case detected.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(foo, bar)
        end

        
      end
    RUBY
  end

  def test_checks_only_minitest_test_children
    assert_no_offenses(<<~RUBY)
      class FooTest
        def test_aempty
        end
      end
    RUBY
  end

  def test_checks_only_test_case_methods
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def no_test_prefix
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_non_empty_test_case
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(foo, bar)
        end
      end
    RUBY
  end
end
