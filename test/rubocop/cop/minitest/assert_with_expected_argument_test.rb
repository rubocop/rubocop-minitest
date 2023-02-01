# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertWithExpectedArgumentTest < Minitest::Test
  def test_registers_offense_when_second_argument_is_not_a_string
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          my_list = [1, 2, 3]
          assert(3, my_list.length)
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Did you mean to use `assert_equal(3, my_list.length)`?
        end
      end
    RUBY
  end

  def test_registers_offense_when_second_argument_is_a_variable
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          my_list_length = 3
          assert(3, my_list_length)
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Did you mean to use `assert_equal(3, my_list_length)`?
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_assert_is_called_with_one_argument
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(true)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_second_argument_is_a_literal_string
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert([], "empty array should be truthy")
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_second_argument_is_a_variable_named_message
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert([], message)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_second_argument_is_a_variable_named_msg
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert([], msg)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_second_argument_is_an_interpolated_string
    assert_no_offenses(<<~'RUBY')
      class FooTest < Minitest::Test
        def test_do_something
          additional_message = 'hello world'
          assert([], "empty array should be truthy #{additional_message}")
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_equal_with_two_arguments
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_equal(3, actual)
        end
      end
    RUBY
  end
end
