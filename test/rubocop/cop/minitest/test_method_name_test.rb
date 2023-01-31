# frozen_string_literal: true

require_relative '../../../test_helper'

class TestMethodNameTest < Minitest::Test
  def test_registers_offense_when_test_method_without_prefix
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(expected, actual)
        end

        def do_something_else
            ^^^^^^^^^^^^^^^^^ Test method name should start with `test_` prefix.
          assert_equal(expected, actual)
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(expected, actual)
        end

        def test_do_something_else
          assert_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_registers_offense_when_test_method_without_prefix_with_multiple_assertions
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(expected, actual)
          assert_equal expected, actual
        end

        def do_something_else
            ^^^^^^^^^^^^^^^^^ Test method name should start with `test_` prefix.
          assert_equal(expected, actual)
          assert_equal expected, actual
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(expected, actual)
          assert_equal expected, actual
        end

        def test_do_something_else
          assert_equal(expected, actual)
          assert_equal expected, actual
        end
      end
    RUBY
  end

  def test_checks_only_test_classes
    assert_no_offenses(<<~RUBY)
      class FooTest
        def do_something
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_hook_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def setup
          assert_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_non_public_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        private

        def do_something
          assert_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_defining_test_method_has_an_argument
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def do_something(arg)
          assert_equal(expected, actual)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_defining_test_method_without_assertion_methods
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def do_something
          foo
        end
      end
    RUBY
  end
end
