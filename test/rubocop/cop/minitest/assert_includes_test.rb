# frozen_string_literal: true

require 'test_helper'

class AssertIncludesTest < Minitest::Test
  def test_registers_offense_when_using_assert_with_include
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.include?(object))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(collection, object)` over `assert(collection.include?(object))`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(collection, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_include_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.include?(object), 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(collection, object, 'the message')` over `assert(collection.include?(object), 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(collection, object, 'the message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_include_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.include?(object), <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(collection, object, <<~MESSAGE)` over `assert(collection.include?(object), <<~MESSAGE)`.
            the message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(collection, object, <<~MESSAGE
            the message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_include_in_redundant_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert((collection.include?(object)))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(collection, object)` over `assert(collection.include?(object))`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes((collection, object))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_includes_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(collection, object)
        end
      end
    RUBY
  end

  def test_does_not_registers_offense_when_using_assert_with_non_include_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.end_with?(string))
        end
      end
    RUBY
  end
end
