# frozen_string_literal: true

require 'test_helper'

class RepeatedTestCaseNameTest < Minitest::Test
  def test_registers_offense_when_repeated_test_case_name
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
        end

        def test_do_something_else
        end

        def test_do_something
            ^^^^^^^^^^^^^^^^^ Repeated test case name detected.
        end
      end
    RUBY
  end

  def test_checks_only_minitest_test_children
    assert_no_offenses(<<~RUBY)
      class FooTest
        def test_do_something
        end

        def test_do_something
        end
      end
    RUBY
  end

  def test_checks_only_test_case_methods
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def do_something
        end

        def do_something
        end
      end
    RUBY
  end
end
