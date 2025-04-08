# frozen_string_literal: true

require_relative '../../../test_helper'

class NoAssertionsTest < Minitest::Test
  def test_registers_offense_when_no_assertions
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        include Foo

        setup { }
        teardown { }

        def test_valid_test
          assert true
        end

        def test_the_truth
            ^^^^^^^^^^^^^^ Test case has no assertions.
        end

        def test_another_valid_test
          assert true
        end
      end
    RUBY
  end

  def test_registers_offense_when_no_assertions_in_test_block_form
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        include Foo

        setup { }
        teardown { }

        test "valid test" do
          assert true
        end

        test "the truth" do
        ^^^^^^^^^^^^^^^^^^^ Test case has no assertions.
        end

        test "another valid test" do
          assert true
        end
      end
    RUBY
  end

  def test_registers_offense_when_no_assertions_in_it_block_form
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        describe Foo do
          setup { }
          teardown { }

          it "asserts the truth" do
            assert true
          end

          it "does nothing" do
          ^^^^^^^^^^^^^^^^^^^^ Test case has no assertions.
          end
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

  def test_register_no_offense_if_test_has_must_be_empty_assertion
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        describe 'foo' do
          it 'must have good data' do
            _(invalid_recs).must_be_empty ->{ do_something }
          end
        end
      end
    RUBY
  end

  def test_register_no_offense_if_test_has_must_include_assertion
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        describe 'foo' do
          it 'must include [false, true]' do
            value([false, true]).must_include value
          end
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
