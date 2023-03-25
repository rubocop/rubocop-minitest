# frozen_string_literal: true

require_relative '../../../test_helper'

class NoTestCases < Minitest::Test
  def test_registers_offense_for_empty_test_class
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Test class should have test cases.
      end
    RUBY
  end

  def test_registers_offense_for_nonempty_test_class_with_no_test_cases
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Test class should have test cases.
        def perform
          1 + 2
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_test_class_has_test_case
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo; end
      end
    RUBY
  end

  def test_considers_active_support_test_example_format
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        test 'something' do; end
      end
    RUBY
  end

  def test_does_not_register_offense_for_non_test_classes
    assert_no_offenses(<<~RUBY)
      class FooTest
        def perform; end
      end
    RUBY
  end
end
