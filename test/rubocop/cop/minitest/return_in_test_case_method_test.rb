# frozen_string_literal: true

require_relative '../../../test_helper'

class ReturnInTestMethodTest < Minitest::Test
  def test_registers_offense_when_using_return_inside_test_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
          return if something?
          ^^^^^^ Use `skip` instead of `return`.
          assert_equal foo, bar
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
          skip if something?
          assert_equal foo, bar
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_return_with_argument_inside_test_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
          return baz if something?
          ^^^^^^^^^^ Use `skip` instead of `return`.
          assert_equal foo, bar
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
          skip if something?
          assert_equal foo, bar
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_return_inside_regular_method
    assert_no_offenses(<<~RUBY)
      def foo
        return if something?
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_return_at_top_level
    assert_no_offenses(<<~RUBY)
      return if something?
    RUBY
  end

  def test_does_not_register_offense_when_using_skip
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
          skip if something?
          assert_equal foo, bar
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_return_inside_block
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
          Foo.class_eval do
            def foo
              return 100
            end
          end
          assert_equal 100, Foo.new.foo
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_return_inside_numblock
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_foo
          Foo.class_eval do
            _1.extend(ClassMethods)
            def foo
              return 100
            end
          end
          assert_equal 100, Foo.new.foo
        end
      end
    RUBY
  end
end
