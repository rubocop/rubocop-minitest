# frozen_string_literal: true

require_relative '../../../test_helper'

class UnspecifiedExceptionTest < RuboCop::Minitest::Test
  def test_registers_offense_when_using_assert_raises_without_exception
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_raises { raise FooException }
          ^^^^^^^^^^^^^ Specify the exception being captured.
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_raises_with_only_message_specified
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_raises('This should have raised') { raise FooException }
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Specify the exception being captured.
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_raises_with_exception
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_raises(FooException) { raise FooException }
        end
      end
    RUBY
  end
end
