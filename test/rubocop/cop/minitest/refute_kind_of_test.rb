# frozen_string_literal: true

require_relative '../../../test_helper'

class RefuteKindOfTest < RuboCop::Minitest::Test
  def test_registers_offense_when_using_refute_with_kind_of
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.kind_of?(SomeClass))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_kind_of(SomeClass, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_kind_of(SomeClass, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_kind_of_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.kind_of?(SomeClass), 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_kind_of(SomeClass, object, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_kind_of(SomeClass, object, 'message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_kind_of_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_kind_of(SomeClass, object)
        end
      end
    RUBY
  end
end
