# frozen_string_literal: true

require 'test_helper'

class RefuteInstanceOfTest < Minitest::Test
  def test_registers_offense_when_using_refute_with_instance_of
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.instance_of?(SomeClass))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_instance_of(SomeClass, object)` over `refute(object.instance_of?(SomeClass))`.
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
          refute(object.instance_of?(SomeClass), 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_instance_of(SomeClass, object, 'the message')` over `refute(object.instance_of?(SomeClass), 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, object, 'the message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_instance_of_operator_with_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.instance_of?(SomeClass), <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_instance_of(SomeClass, object, <<~MESSAGE)` over `refute(object.instance_of?(SomeClass), <<~MESSAGE)`.
            the message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, object, <<~MESSAGE
            the message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def refute_instance_of_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_instance_of(SomeClass, object)
        end
      end
    RUBY
  end
end
