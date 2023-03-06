# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertOutputTest < Minitest::Test
  def test_registers_offense_when_mutating_output_global_variable
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          $stdout = StringIO.new
          puts object.method
          $stdout.rewind
          assert_match expected, $stdout.read
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `assert_output` instead of mutating $stdout.
        end
      end
    RUBY
  end

  def test_registers_offense_when_mutating_output_global_variable_in_it_block_form
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        describe Foo do
          it "does something" do
            $stdout = StringIO.new
            puts object.method
            $stdout.rewind
            assert_match expected, $stdout.read
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `assert_output` instead of mutating $stdout.
          end
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_not_inside_test_case
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def setup
          $stdout = StringIO.new
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_mutating_custom_global_variable
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          $myvariable = foo
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_mutating_output_global_variable_and_not_asserting_on_it
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          $stdout = StringIO.new
          assert_equal foo, bar
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_gvar_at_top_level
    assert_no_offenses(<<~RUBY)
      $foo = false
    RUBY
  end
end
