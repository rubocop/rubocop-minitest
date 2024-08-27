# frozen_string_literal: true

require_relative '../../../test_helper'

class MultipleAssertionsTest < Minitest::Test
  def setup
    configure_max_assertions(1)
  end

  def test_registers_offense_when_multiple_expectations
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_twice
        ^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_expectations_with_block
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_two_times
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          assert_raises(SomeError) do
            assert_equal(baz, bar)
          end
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_expectations_with_numblock
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_two_times
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          assert_something do
            assert_equal(_1, bar)
          end
        end
      end
    RUBY
  end

  def test_checks_when_inheriting_some_class_and_class_name_ending_with_test
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        def test_asserts_twice
        ^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_checks_when_inheriting_some_class_and_class_name_does_end_with_test
    assert_no_offenses(<<~RUBY)
      class Foo < Base
        def test_asserts_twice
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_checks_when_not_inheriting_some_class_and_class_name_ending_with_test
    assert_no_offenses(<<~RUBY)
      class FooTest
        def test_asserts_twice
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_checks_only_test_case_methods
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        # No 'test_' prefix
        def asserts_twice
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_single_assertion
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_once
          assert_equal(foo, bar)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assigning_a_value_to_an_object_attribute
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_once
          obj.value = 42

          assert_equal(foo, bar)
        end
      end
    RUBY
  end

  def test_does_not_crash_with_mass_assignments
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_does_not_crash
          _, _ = foo
          _, _ = []
          _, _ = {}
          _, _ = ''
          _, _ = 1
        end
      end
    RUBY
  end

  def test_all_types_of_assignments_are_understood
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_all_types_of_assignment
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [8/1].
          # lvasgn
          foo = assert_equal(1, 1)
          # ivasgn
          @instance_variable = assert_equal(1, 1)
          # cvasgn
          @@class_variable = assert_equal(1, 1)
          # gvasgn
          $global_variable = assert_equal(1, 1)
          # casgn
          # MyClass::CONSTANT_VALUE = assert_equal(1, 1)
          # masgn
          a, b, c = assert_equal(1, 1)
          a, b, c = [assert_equal(1, 1), assert_equal(1, 1), assert_equal(1, 1)]
          # op_asgn
          counter += assert_equal(1, 1)
          # or_asgn
          result ||= assert_equal(1, 1)
          # and_asgn
          flag &&= assert_equal(1, 1)
        end
      end
    RUBY
  end

  def test_assignments_are_not_counted_twice
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_once
          _ = assert_equal(1, 2)
        end
      end
    RUBY
  end

  def test_assignments_are_counted_normally
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_twice
        ^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          _ = assert_equal(1, 2)
          _ = assert_equal(1, 2)
        end
      end
    RUBY
  end

  def test_assignments_are_not_counted_complex
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test "#render errors include stack traces" do
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [3/1].
          err = assert_raises React::ServerRendering::PrerenderError do
            @renderer.render("NonExistentComponent", {}, nil)
          end

          assert_match(/NonExistentComponent/, err.to_s, "it names the component")

          assert_match(/\n/, err.to_s, "it includes the multi-line backtrace")
        end
      end
    RUBY
  end

  def test_assignments_are_not_counted_but_block_bodies_still_are
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test "#render errors include stack traces" do
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [5/1].
          err = assert_raises React::ServerRendering::PrerenderError do
            @renderer.render("NonExistentComponent", {}, nil)
            assert_equal 1, 1
            assert_equal 1, 1
          end

          assert_match(/NonExistentComponent/, err.to_s, "it names the component")

          assert_match(/\n/, err.to_s, "it includes the multi-line backtrace")
        end
      end
    RUBY
  end

  def test_assignments_with_nested_blocks_are_counted_correctly
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test "#render errors include stack traces" do
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [9/1].
          err = assert_raises React::ServerRendering::PrerenderError do
            assert_equal 1, 1

            assert_raises React::ServerRendering::PrerenderError do
              assert_equal 1, 1
            end

            _ = assert_raises React::ServerRendering::PrerenderError do
              assert_equal 1, 1
              assert_equal 1, 1
            end
          end

          assert_match(/NonExistentComponent/, err.to_s, "it names the component")

          assert_match(/\n/, err.to_s, "it includes the multi-line backtrace")
        end
      end
    RUBY
  end

  def test_assignments_with_numblocks_are_counted_correctly
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test "#render errors include stack traces" do
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [9/1].
          err = assert_raises React::ServerRendering::PrerenderError do
            assert_equal _1, 1

            assert_raises React::ServerRendering::PrerenderError do
              assert_equal _1, 1
            end

            _ = assert_raises React::ServerRendering::PrerenderError do
              assert_equal _1, 1
              assert_equal _1, 1
            end
          end

          assert_match(/NonExistentComponent/, err.to_s, "it names the component")

          assert_match(/\n/, err.to_s, "it includes the multi-line backtrace")
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_or_assigning_a_value_to_an_object_attribute
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_once
          var ||= :value

          assert_equal(foo, bar)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_or_assigning_an_assertion_return_value_to_an_object_attribute
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_once
        ^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          var ||= assert_equal(1, 2)

          assert_equal(foo, bar)
        end
      end
    RUBY
  end

  def test_generates_a_todo_based_on_the_worst_violation
    skip 'FIXME: The shared `@cop` instance variable causes flaky tests due to state changes.'

    inspect_source(<<-RUBY, @cop, 'test/foo_test.rb')
      class FooTest < Minitest::Test
        def test_asserts_once
          assert_equal(foo, bar)
        end

        def test_asserts_four_times
          assert_equal(foo, bar)
          assert_equal(foo, bar)
          assert_equal(foo, bar)
          assert_equal(foo, bar)
        end
      end
    RUBY

    assert_equal({ 'Max' => 4 }, @cop.config_to_allow_offenses[:exclude_limit])
  end

  def test_registers_offense_when_multiple_assertions_in_the_test_block
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          assert_equal(foo, bar)
          assert_empty(array)
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_assertions_inside_conditional
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          if condition
            assert_equal(foo, bar) # 1
            assert_empty(array) # 2
          else
            assert_equal(foo, baz)
          end
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_assertions_inside_assigned_conditional
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          _ = if condition
                assert_equal(foo, bar) # 1
                assert_empty(array) # 2
              else
                assert_equal(foo, baz)
              end
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_single_assertion_inside_conditional
    assert_no_offenses(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
          if condition
            assert_equal(foo, bar)
          else
            assert_equal(foo, baz)
          end
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_expectations_inside_case
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [3/1].
          case
          when condition1
            assert_equal(foo, bar)
            assert_empty(array)
          when condition2
            assert_equal(foo, bar) # 1
            assert_empty(array) # 2
            assert_equal(foo, baz) # 3
          else
            assert_equal(foo, zoo)
          end
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_expectations_inside_assigned_case
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [3/1].
          _ = case
              when condition1
                assert_equal(foo, bar)
                assert_empty(array)
              when condition2
                assert_equal(foo, bar) # 1
                assert_empty(array) # 2
                assert_equal(foo, baz) # 3
              else
                assert_equal(foo, zoo)
              end
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_single_assertion_inside_case
    assert_no_offenses(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
          case
          when condition1
            assert_equal(foo, bar)
          else
            assert_equal(foo, zoo)
          end
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_expectations_inside_pattern_matching
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [3/1].
          case variable
          in pattern1
            assert_equal(foo, bar)
            assert_empty(array)
          in pattern2
            assert_equal(foo, bar) # 1
            assert_empty(array) # 2
            assert_equal(foo, baz) # 3
          else
            assert_equal(foo, zoo)
          end
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_expectations_inside_assigned_pattern_matching
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [3/1].
          _ = case variable
              in pattern1
                assert_equal(foo, bar)
                assert_empty(array)
              in pattern2
                assert_equal(foo, bar) # 1
                assert_empty(array) # 2
                assert_equal(foo, baz) # 3
              else
                assert_equal(foo, zoo)
              end
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_single_assertion_inside_pattern_matching
    assert_no_offenses(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
          case variable
          in pattern1
            assert_equal(foo, bar)
          in pattern2
            assert_equal(foo, baz)
          end
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_expectations_inside_rescue
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [3/1].
          do_something
        rescue Foo
          assert_equal(foo, bar)
          assert_empty(array)
        rescue Bar
          assert_equal(foo, bar) # 1
          assert_empty(array) # 2
          assert_equal(foo, baz) # 3
        end
      end
    RUBY
  end

  def test_registers_offense_when_multiple_expectations_inside_assigned_rescue
    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [3/1].
          _ = begin
                do_something
              rescue Foo
                assert_equal(foo, bar)
                assert_empty(array)
              rescue Bar
                assert_equal(foo, bar) # 1
                assert_empty(array) # 2
                assert_equal(foo, baz) # 3
              end
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_single_assertion_inside_rescue
    assert_no_offenses(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
          do_something
        rescue Foo
          assert_equal(foo, bar)
        end
      end
    RUBY
  end

  def test_registers_offense_when_complex_structure_with_multiple_assertions
    skip 'FIXME: The shared `@cop` instance variable causes flaky tests due to state changes.'

    configure_max_assertions(2)

    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [4/2].
          if condition1
            assert foo
          elsif condition2
            assert foo
          else
            begin
              do_something
              assert foo # 1
            rescue Foo
              assert foo
              assert foo
            rescue Bar
              # noop
            rescue Zoo
              case
              when condition
                assert foo # 2
                assert foo # 3
                assert foo # 4
              else
                assert foo
                assert foo
              end
            else
              assert foo
            end
          end
        end
      end
    RUBY
  end

  def test_registers_offense_when_complex_structure_with_assignments_and_multiple_assertions
    skip 'FIXME: The shared `@cop` instance variable causes flaky tests due to state changes.'

    configure_max_assertions(2)

    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [4/2].
          _= if condition1
               assert foo
             elsif condition2
               assert foo
             else
               begin
                 do_something
                 assert foo # 1
               rescue Foo
                 assert foo
                 assert foo
               rescue Bar
                 # noop
               rescue Zoo
                 _ = case
                     when condition
                       assert foo # 2
                       assert foo # 3
                       assert foo # 4
                     else
                       assert foo
                       assert foo
                     end
               else
                 assert foo
               end
             end
        end
      end
    RUBY
  end

  def test_registers_offense_when_for_style_loop
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_asserts_twice
        ^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
          assert_equal(foo, bar)
          for baz in [1, 2]
            assert_equal(baz, 1)
          end
        end
      end
    RUBY
  end

  def test_registers_offense_when_complex_multiple_assignment_structure_and_multiple_assertions
    skip 'FIXME: The shared `@cop` instance variable causes flaky tests due to state changes.'

    configure_max_assertions(2)

    assert_offense(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
        ^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [5/2].
          _, _, _ = [
             if condition1
               assert foo
             else
               assert foo
             end,
             begin
               do_something
               assert foo # 1
             rescue Foo
               assert foo
               assert foo
             rescue Bar
               # noop
             rescue Zoo
               _ = case
                   when condition
                     assert foo # 2
                     assert foo # 3
                     assert foo # 4
                   else
                     assert foo
                     assert foo
                   end
             else
               assert foo
             end,
             assert(foo)
          ]
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_complex_structure_with_single_assertion
    assert_no_offenses(<<~RUBY)
      class FooTest < ActiveSupport::TestCase
        test 'something' do
          if condition1
            assert foo
          elsif condition2
            assert foo
          else
            begin
              do_something
            rescue Foo
              assert foo
            rescue Bar
              # noop
            rescue Zoo
              case
              when condition
                assert foo
              else
                assert foo
              end
            else
              assert foo
            end
          end
        end
      end
    RUBY
  end

  private

  def configure_max_assertions(max)
    cop_config = RuboCop::Config.new('Minitest/MultipleAssertions' => { 'Max' => max })
    @cop = RuboCop::Cop::Minitest::MultipleAssertions.new(cop_config)
  end
end
