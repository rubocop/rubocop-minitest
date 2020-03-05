# frozen_string_literal: true

require 'test_helper'

class AssertInstanceOfTest < Minitest::Test
  def test_registers_offense_when_using_assert_with_instance_of
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(object.instance_of?(SomeClass))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_instance_of(SomeClass, object)` over `assert(object.instance_of?(SomeClass))`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_instance_of(SomeClass, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_instance_of_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(object.instance_of?(SomeClass), 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_instance_of(SomeClass, object, 'message')` over `assert(object.instance_of?(SomeClass), 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_instance_of(SomeClass, object, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_instance_of_operator_with_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(object.instance_of?(SomeClass), <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_instance_of(SomeClass, object, <<~MESSAGE)` over `assert(object.instance_of?(SomeClass), <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_instance_of(SomeClass, object, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_instance_of_in_redundant_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert((object.instance_of?(SomeClass)))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_instance_of(SomeClass, object)` over `assert(object.instance_of?(SomeClass))`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_instance_of((SomeClass, object))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_instance_of_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_instance_of(SomeClass, object)
        end
      end
    RUBY
  end
end
