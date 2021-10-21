# frozen_string_literal: true

require 'test_helper'

class AssertEmptyTest < Minitest::Test
  def test_registers_offense_when_using_assert_with_empty
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff.empty?)
          ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff)` over `assert(somestuff.empty?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_empty_and_string_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff.empty?, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff, 'message')` over `assert(somestuff.empty?, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty(somestuff, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_empty_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(somestuff.empty?, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff, <<~MESSAGE)` over `assert(somestuff.empty?, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty(somestuff, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_empty_in_redundant_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert((somestuff.empty?))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_empty(somestuff)` over `assert(somestuff.empty?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty((somestuff))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_empty_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_empty(somestuff)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_empty_method_with_any_arguments
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(File.empty?(path))
        end
      end
    RUBY
  end
end
