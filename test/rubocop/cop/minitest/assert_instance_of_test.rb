# frozen_string_literal: true

require 'test_helper'

class AssertInstanceOfTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::AssertInstanceOf.new
  end

  def test_registers_offense_when_using_assert_with_instance_of
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert(object.instance_of?(SomeClass))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_instance_of(SomeClass, object)` over `assert(object.instance_of?(SomeClass))`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_instance_of(SomeClass, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_instance_of_and_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert(object.instance_of?(SomeClass), 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_instance_of(SomeClass, object, 'the message')` over `assert(object.instance_of?(SomeClass), 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_instance_of(SomeClass, object, 'the message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_instance_of_method
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          assert_instance_of(SomeClass, object)
        end
      end
    RUBY
  end
end
