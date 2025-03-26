# frozen_string_literal: true

require_relative '../../../test_helper'

class RefutePredicateTest < Minitest::Test
  def test_registers_offense_when_using_refute_with_predicate_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.one?)
          ^^^^^^^^^^^^^^^^ Prefer using `refute_predicate(obj, :one?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_predicate(obj, :one?)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_predicate_method_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.one?, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_predicate(obj, :one?, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_predicate(obj, :one?, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_predicate_method_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.one?, <<~MESSAGE)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_predicate(obj, :one?, <<~MESSAGE)`.
            message
          MESSAGE
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_predicate(obj, :one?, <<~MESSAGE)
            message
          MESSAGE
        end
      end
    RUBY
  end

  # Redundant parentheses should be removed by `Style/RedundantParentheses` cop.
  def test_does_not_register_offense_when_using_refute_with_predicate_method_in_redundant_parentheses
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute((obj.one?))
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_receiver_omitted_predicate_method
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(one?)
          ^^^^^^^^^^^^ Prefer using `refute_predicate(self, :one?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_predicate(self, :one?)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_predicate_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_predicate(obj, :one?)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_non_predicate_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.do_something)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_local_variable
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          obj = create_obj
          refute(obj)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_predicate_method_and_arguments
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(obj.foo?(arg))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_predicate_method_and_numbered_parameters
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute([1, 2, 3].any? { some_filter_function _1 })
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_predicate_method_and_it_parameter
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute([1, 2, 3].any? { some_filter_function it })
        end
      end
    RUBY
  end
end
