# frozen_string_literal: true

require 'test_helper'

class NoAssertionsTest < Minitest::Test
  def test_registers_offense_when_no_assertions
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_the_truth
            ^^^^^^^^^^^^^^ Test case has no assertions.
        end
      end
    RUBY
  end

  def test_registers_offense_when_no_assertions_in_block_form
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        test "the truth" do
        ^^^^^^^^^^^^^^^^^^^ Test case has no assertions.
        end
      end
    RUBY
  end

  def test_register_no_offense_if_test_has_assertion
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_the_truth
          assert true
        end
      end
    RUBY
  end

  def test_register_no_offense_for_unrelated_methods
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def foo_bar
          puts "this isn't a test"
        end
      end
    RUBY
  end

  def test_register_no_offense_for_unrelated_blocks
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        foo "bar" do
          puts "this isn't a test"
        end
      end
    RUBY
  end

  def test_register_no_offense_if_test_flunks
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_the_truth
          flunk
        end
      end
    RUBY
  end
end
