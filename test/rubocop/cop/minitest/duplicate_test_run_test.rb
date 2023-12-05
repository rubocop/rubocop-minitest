# frozen_string_literal: true

require_relative '../../../test_helper'

class DuplicateTestRunTest < RuboCop::Minitest::Test
  def test_registers_offense_when_parent_and_child_have_tests_methods
    assert_offense(<<~RUBY)
      class ParentTest < Minitest::Test
        def test_parent
        end
      end

      class ChildTest < ParentTest
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Subclasses with test methods causes the parent' tests to run them twice.
        def test_child_asserts_twice
          assert_equal(1, 1)
        end
      end
    RUBY
  end

  def test_registers_offense_when_parent_and_children_have_tests_methods
    assert_offense(<<~RUBY)
      class ParentTest < Minitest::Test
        def test_parent
        end
      end

      class Child1Test < ParentTest
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Subclasses with test methods causes the parent' tests to run them twice.
        def test_parent
        end
      end

      class Child2Test < ParentTest
      end

      class Child3Test < ParentTest
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Subclasses with test methods causes the parent' tests to run them twice.
        def test_1_child_2_asserts_twice
        end

        def test_2_child_2_asserts_twice
        end

        def test_3_child_2_asserts_twice
        end
      end
    RUBY
  end

  def test_does_not_register_offense_if_the_parent_does_not_have_test_methods
    assert_no_offenses(<<~RUBY)
      class ParentTest < Minitest::Test
      end

      class ChildTest < ParentTest
        def test_child_asserts_twice
          assert_equal(1, 1)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_if_the_child_does_not_have_test_methods
    assert_no_offenses(<<~RUBY)
      class ParentTest < Minitest::Test
        def test_child_asserts_twice
          assert_equal(1, 1)
        end
      end

      class ChildTest < ParentTest
      end
    RUBY
  end

  def test_does_not_register_offense_if_the_class_has_no_children
    assert_no_offenses(<<~RUBY)
      class ParentTest < Minitest::Test
        def test_child_asserts_twice
          assert_equal(1, 1)
        end
      end

      class ClassTwo < ParentTest
      end
    RUBY
  end

  def test_does_not_register_offense_if_the_class_is_not_a_test_class
    assert_no_offenses(<<~RUBY)
      class ParentTest < ExampleClass
        def test_child_asserts_twice
          assert_equal(1, 1)
        end
      end

      class ChildClass < ParentTest
        def test_child_asserts_twice
          assert_equal(1, 1)
        end
      end
    RUBY
  end

  def test_does_not_throw_error_if_missing_parent_test_class
    assert_no_offenses(<<~RUBY)
      class PostmarkAccountServiceTest < ActionDispatch::IntegrationTest
        test "it handles missing payloads from Postmark Account API errors" do
          Postmark::AccountApiClient.any_instance.stubs(:create_server).raises(StandardError)

          Rails.logger.expects(:error)
          PostmarkAccountService.create_server({})
        end
      end
    RUBY
  end
end
