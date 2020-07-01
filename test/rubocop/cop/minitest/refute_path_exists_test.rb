# frozen_string_literal: true

require 'test_helper'

class RefutePathExistsTest < Minitest::Test
  def test_registers_offense_when_using_refute_file_exist
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(File.exist?(path))
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_path_exists(path)` over `refute(File.exist?(path))`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_path_exists(path)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_file_exist_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(File.exist?(path), 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_path_exists(path, 'message')` over `refute(File.exist?(path), 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_path_exists(path, 'message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_path_exists_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_path_exists(path)
        end
      end
    RUBY
  end
end
