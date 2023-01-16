# frozen_string_literal: true

require 'test_helper'

class TestFileNameTest < Minitest::Test
  def test_registers_offense_for_invalid_path
    offenses = inspect_source(<<~RUBY, @cop, 'lib/foo.rb')
      class FooTest < Minitest::Test
      end
    RUBY
    message = 'Test file path should start with `test_` or end with `_test.rb`.'

    assert_equal(1, offenses.size)
    assert_equal(message, offenses.first.message)
  end

  def test_registers_offense_for_namespaced_invalid_path
    offenses = inspect_source(<<~RUBY, @cop, 'lib/foo/bar.rb')
      module Foo
        class BarTest < Minitest::Test
        end
      end
    RUBY
    message = 'Test file path should start with `test_` or end with `_test.rb`.'

    assert_equal(1, offenses.size)
    assert_equal(message, offenses.first.message)
  end

  def test_does_not_register_offense_for_files_starting_with_test
    assert_no_offenses(<<~RUBY, 'lib/test_foo.rb')
      class FooTest < Minitest::Test; end
    RUBY
  end

  def test_does_not_register_offense_for_files_ending_with_test
    assert_no_offenses(<<~RUBY, 'lib/foo_test.rb')
      class FooTest < Minitest::Test; end
    RUBY
  end

  def test_does_not_register_offense_for_non_test_classes
    assert_no_offenses(<<~RUBY, 'lib/foo.rb')
      class Foo; end
    RUBY
  end

  def test_does_not_register_offense_for_empty_file
    assert_no_offenses('', 'lib/foo.rb')
  end
end
