# frozen_string_literal: true

require 'test_helper'

class RefuteIncludesTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::RefuteIncludes.new
  end

  def test_registers_offense_when_using_refute_with_include
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(collection.include?(object))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_includes(collection, object)` over `refute(collection.include?(object))`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_includes(collection, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_include_and_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(collection.include?(object), 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_includes(collection, object, 'the message')` over `refute(collection.include?(object), 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_includes(collection, object, 'the message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_includes_method
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_includes(collection, object)
        end
      end
    RUBY
  end
end
