# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertPredicateTest < Minitest::Test
  def test_registers_offense_when_using_assert_with_predicate_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.one?)
          ^^^^^^^^^^^^^^^^ Prefer using `assert_predicate(obj, :one?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_predicate(obj, :one?)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_predicate_method_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.one?, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_predicate(obj, :one?, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_predicate(obj, :one?, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_predicate_method_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.one?, <<~MESSAGE)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_predicate(obj, :one?, <<~MESSAGE)`.
            message
          MESSAGE
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_predicate(obj, :one?, <<~MESSAGE)
            message
          MESSAGE
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_predicate_method_in_redundant_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert((obj.one?))
          ^^^^^^^^^^^^^^^^^^ Prefer using `assert_predicate(obj, :one?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_predicate(obj, :one?)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_receiver_omitted_predicate_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(one?)
          ^^^^^^^^^^^^ Prefer using `assert_predicate(self, :one?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_predicate(self, :one?)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_predicate_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_predicate(obj, :one?)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_with_non_predicate_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.do_something)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_with_local_variable
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          obj = create_obj
          assert(obj)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_with_predicate_method_and_arguments
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(obj.foo?(arg))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_with_predicate_method_and_numbered_parameters
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert([1, 2, 3].any? { some_filter_function _1 })
        end
      end
    RUBY
  end

  def test_does_not_raise_error_using_assert_with_block
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert { true }
        end
      end
    RUBY
  end
end
