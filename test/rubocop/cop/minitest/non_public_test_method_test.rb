# frozen_string_literal: true

require 'test_helper'

class NonPublicTestMethodTest < Minitest::Test
  def test_registers_offense_when_using_private_test_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        private
        def test_does_something
        ^^^^^^^^^^^^^^^^^^^^^^^ Non `public` test method detected. Make it `public` for it to run.
          assert_equal 42, do_something
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_protected_test_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        protected
        def test_does_something
        ^^^^^^^^^^^^^^^^^^^^^^^ Non `public` test method detected. Make it `public` for it to run.
          assert_equal 42, do_something
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_private_test_method_outside_of_test_class
    assert_offense(<<~RUBY)
      class FooTest
        private
        def test_does_something
        ^^^^^^^^^^^^^^^^^^^^^^^ Non `public` test method detected. Make it `public` for it to run.
          assert_equal 42, do_something
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_private_active_support_test_method
    assert_offense(<<~RUBY)
      class FooTest
        private
        test "does something"  do
        ^^^^^^^^^^^^^^^^^^^^^^^^^ Non `public` test method detected. Make it `public` for it to run.
          assert_equal 42, do_something
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_private_non_test_method_with_assertions
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        private
        def does_something
          assert_equal 42, do_something
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_private_test_method_without_assertions
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        private
        def test_does_something
          do_something
        end
      end
    RUBY
  end
end
