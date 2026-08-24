# frozen_string_literal: true

require_relative '../../../test_helper'

class NoTestCases < RuboCop::TestCase
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

  def test_considers_active_support_test_example_generated_at_class_level
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        [1, 2].each do |number|
          test 'something' do; end
        end
      end
    RUBY
  end

  def test_registers_offense_when_the_only_test_example_is_inside_a_method_definition
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Test class should have test cases.
        def build_matrix(cases)
          cases.each do |name|
            it(name) { skip }
          end
        end
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
