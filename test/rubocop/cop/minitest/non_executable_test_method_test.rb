# frozen_string_literal: true

require_relative '../../../test_helper'

class NonExecutableTestMethodTest < Minitest::Test
  def test_registers_offense_when_test_method_is_defined_outside_minitest_test_class
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
      end
      def test_foo
      ^^^^^^^^^^^^ Test method should be defined inside a test class to ensure execution.
      end
    RUBY
  end

  def test_registers_offense_when_test_method_is_defined_outside_active_support_test_case_class
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
      end

      def test_foo
      ^^^^^^^^^^^^ Test method should be defined inside a test class to ensure execution.
      end
    RUBY
  end

  def test_does_not_register_offense_when_test_method_is_defined_outside_namespaced_test_class
    assert_offense(<<~RUBY)
      module M
        class FooTest < Minitest::Test
          def test_foo
          end
        end

        def test_bar
        ^^^^^^^^^^^^ Test method should be defined inside a test class to ensure execution.
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_non_test_method_is_defined_outside_test_class
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
      end
      def do_something
      end
    RUBY
  end

  def test_does_not_register_offense_when_non_test_method_is_defined_outside_active_support_test_case_class
    assert_no_offenses(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
      end
      def do_something
      end
    RUBY
  end

  def test_does_not_register_offense_when_test_method_is_defined_inside_test_class
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_test_method_is_defined_inside_test_helper_class
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
        end
      end

      class TestHelperMailer < ActionMailer::Base
        def test_parameter_args
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_test_method_is_defined_inside_test_helper_module
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
        end
      end

      module TestHelper
        def test_parameter_args
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_test_class_in_which_test_method_is_defined_is_repeated
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
        end
      end

      class FooTest < Minitest::Test
        def test_foo
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_test_method_is_defined_and_test_class_is_not_defined
    assert_no_offenses(<<~RUBY)
      def test_something
      end
    RUBY
  end

  def test_does_not_register_offense_when_test_method_is_defined_inside_condition
    assert_no_offenses(<<~RUBY)
      module ActiveRecord
        class AdapterTest < ActiveRecord::TestCase
          unless current_adapter?(:PostgreSQLAdapter)
            def test_update_prepared_statement
            end
          end
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_nested_test_method_and_two_test_classes_are_defined
    assert_no_offenses(<<~RUBY)
      class FooTest < ActiveRecord::TestCase
        def test_foo
          def test_bar
          end
        end
      end

      class BarTest < ActiveRecord::TestCase
      end
    RUBY
  end

  def test_does_not_register_offense_when_non_test_case_class_is_defined_before_test_method
    assert_no_offenses(<<~RUBY)
      class SetTest < ActiveRecord::AbstractMysqlTestCase
        class SetTest < ActiveRecord::Base
        end

        def test_should_not_be_unsigned
          column = SetTest.columns_hash["set_column"]
          assert_not_predicate column, :unsigned?
        end
      end
    RUBY
  end
end
