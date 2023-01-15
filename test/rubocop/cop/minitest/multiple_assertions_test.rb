# frozen_string_literal: true

require 'test_helper'

class MultipleAssertionsTest < Minitest::Test
  def setup
    configure_max_assertions(1)
  end

  def test_registers_offense_when_multiple_expectations
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_twice
        ^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_expectations_with_block
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_three_times
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [3/1].
          assert_equal(foo, bar)
          assert_raises(SomeError) do
            assert_equal(baz, bar)
          end
        end
      end
    RUBY
  end

  def test_checks_when_inheriting_some_class_and_class_name_ending_with_test
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        def test_asserts_twice
        ^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_checks_when_inheriting_some_class_and_class_name_does_end_with_test
    assert_no_offenses(<<~RUBY)
      class Foo < Base
        def test_asserts_twice
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_checks_when_not_inheriting_some_class_and_class_name_ending_with_test
    assert_no_offenses(<<~RUBY)
      class FooTest
        def test_asserts_twice
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_checks_only_test_case_methods
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        # No 'test_' prefix
        def asserts_twice
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_single_assertion
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_once
          assert_equal(foo, bar)
        end
      end
    RUBY
  end

  def test_generates_a_todo_based_on_the_worst_violation
    inspect_source(<<-RUBY, @cop, 'test/foo_test.rb')
      class FooTest < Minitest::Test
        def test_asserts_once
          assert_equal(foo, bar)
          assert_equal(baz, bar)
        end

        def test_asserts_two_times
          assert_equal(foo, bar)
          assert_equal(baz, bar)
        end
      end
    RUBY

    assert_equal({ 'Max' => 2 }, @cop.config_to_allow_offenses[:exclude_limit])
  end

  def test_does_not_register_offense_when_multiple_expectations_in_the_test_block
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  private

  def configure_max_assertions(max)
    cop_config = RuboCop::Config.new('Minitest/MultipleAssertions' => { 'Max' => max })
    @cop = RuboCop::Cop::Minitest::MultipleAssertions.new(cop_config)
  end
end
