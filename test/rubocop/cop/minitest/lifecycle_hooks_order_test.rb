# frozen_string_literal: true

require_relative '../../../test_helper'

class LifecycleHooksOrderTest < Minitest::Test
  def test_registers_offense_when_hooks_are_not_correctly_ordered
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def after_teardown
          more_cleanup
        end

        def before_setup; end
        ^^^^^^^^^^^^^^^^^^^^^ `before_setup` is supposed to appear before `after_teardown`.

        def test_something
          assert_equal foo, bar
        end

        def teardown
        ^^^^^^^^^^^^ `teardown` is supposed to appear before `test_something`.
          cleanup
        end

        def setup
        ^^^^^^^^^ `setup` is supposed to appear before `teardown`.
          setup_something
        end

        def test_something_else; end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def before_setup; end
        def setup
          setup_something
        end
        def teardown
          cleanup
        end
        def after_teardown
          more_cleanup
        end


        def test_something
          assert_equal foo, bar
        end



        def test_something_else; end
      end
    RUBY
  end

  def test_registers_offense_when_hooks_are_not_before_test_cases
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_something
          assert_equal foo, bar
        end

        def setup; end
        ^^^^^^^^^^^^^^ `setup` is supposed to appear before `test_something`.
        def teardown; end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def setup; end
        def teardown; end
        def test_something
          assert_equal foo, bar
        end

      end
    RUBY
  end

  def test_does_not_register_offense_when_hooks_after_non_test_cases
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def do_something; end
        def setup; end
        def teardown; end
      end
    RUBY
  end

  def test_correctly_autocorrects_when_there_is_preceding_comment
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        # after_teardown comment
        def after_teardown
          more_cleanup
        end

        # before_setup comment
        def before_setup; end
        ^^^^^^^^^^^^^^^^^^^^^ `before_setup` is supposed to appear before `after_teardown`.
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        # before_setup comment
        def before_setup; end
        # after_teardown comment
        def after_teardown
          more_cleanup
        end

      end
    RUBY
  end

  def test_does_not_register_offense_when_correctly_ordered
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def setup; end
        def teardown; end
      end
    RUBY
  end

  def test_does_not_register_offense_when_not_in_test_class
    assert_no_offenses(<<~RUBY)
      class FooTest
        def teardown; end
        def setup; end
      end
    RUBY
  end

  def test_does_not_register_offense_when_no_callbacks
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test; end
    RUBY
  end
end
