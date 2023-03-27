# frozen_string_literal: true

require_relative '../../../test_helper'

class RefuteInstanceOfTest < Minitest::Test
  def test_registers_offense_when_using_refute_with_instance_of
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.instance_of?(SomeClass))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_instance_of(SomeClass, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_instance_of_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.instance_of?(SomeClass), 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_instance_of(SomeClass, object, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, object, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_instance_of_operator_with_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.instance_of?(SomeClass), <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_instance_of(SomeClass, object, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, object, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_class_arguments
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(SomeClass, obj.class)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_instance_of(SomeClass, obj)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, obj)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_class_arguments_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(SomeClass, obj.class, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_instance_of(SomeClass, obj, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, obj, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_equal_with_class_arguments_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_equal(SomeClass, obj.class, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_instance_of(SomeClass, obj, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, obj, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_instance_of_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, object)
        end
      end
    RUBY
  end
end
