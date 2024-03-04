# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertPathExistsTest < RuboCop::Minitest::Test
  def test_registers_offense_when_using_assert_file_exist
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(File.exist?(path))
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_path_exists(path)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_path_exists(path)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_file_exist_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(File.exist?(path), 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_path_exists(path, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_path_exists(path, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_file_exist_without_without_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert File.exist?(path)
          ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_path_exists path`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_path_exists path
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_file_exist_and_message_without_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert File.exist?(path), 'message'
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_path_exists path, 'message'`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_path_exists path, 'message'
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_path_exists_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_path_exists(path)
        end
      end
    RUBY
  end
end
