# frozen_string_literal: true

require_relative '../../../test_helper'

class RefuteMatchTest < Minitest::Test
  %i[match match? =~].each do |matcher|
    define_method("test_registers_offense_when_using_refute_with_#{matcher}") do
      assert_offense(<<~RUBY, matcher: matcher)
        class FooTest < Minitest::Test
          def test_do_something
            refute(matcher.#{matcher}(object))
            ^^^^^^^^^^^^^^^^{matcher}^^^^^^^^^ Prefer using `refute_match(matcher, object)`.
          end
        end
      RUBY

      assert_correction(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            refute_match(matcher, object)
          end
        end
      RUBY
    end

    define_method("test_registers_offense_when_using_refute_with_#{matcher}_and_lhs_is_regexp_literal") do
      assert_offense(<<~RUBY, matcher: matcher)
        class FooTest < Minitest::Test
          def test_do_something
            refute(/regexp/.#{matcher}(object))
            ^^^^^^^^^^^^^^^^^{matcher}^^^^^^^^^ Prefer using `refute_match(/regexp/, object)`.
          end
        end
      RUBY

      assert_correction(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            refute_match(/regexp/, object)
          end
        end
      RUBY
    end

    define_method("test_registers_offense_when_using_refute_with_#{matcher}_and_rhs_is_regexp_literal") do
      assert_offense(<<~RUBY, matcher: matcher)
        class FooTest < Minitest::Test
          def test_do_something
            refute(object.#{matcher}(/regexp/))
            ^^^^^^^^^^^^^^^{matcher}^^^^^^^^^^^ Prefer using `refute_match(/regexp/, object)`.
          end
        end
      RUBY

      assert_correction(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            refute_match(/regexp/, object)
          end
        end
      RUBY
    end

    define_method("test_registers_offense_when_using_refute_with_#{matcher}_and_message") do
      assert_offense(<<~RUBY, matcher: matcher)
        class FooTest < Minitest::Test
          def test_do_something
            refute(matcher.#{matcher}(object), 'message')
            ^^^^^^^^^^^^^^^^{matcher}^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(matcher, object, 'message')`.
          end
        end
      RUBY

      assert_correction(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            refute_match(matcher, object, 'message')
          end
        end
      RUBY
    end

    define_method("test_registers_offense_when_using_refute_with_#{matcher}_and_heredoc_message") do
      assert_offense(<<~RUBY, matcher: matcher)
        class FooTest < Minitest::Test
          def test_do_something
            refute(matcher.#{matcher}(object), <<~MESSAGE
            ^^^^^^^^^^^^^^^^{matcher}^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(matcher, object, <<~MESSAGE)`.
              message
            MESSAGE
            )
          end
        end
      RUBY

      assert_correction(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            refute_match(matcher, object, <<~MESSAGE
              message
            MESSAGE
            )
          end
        end
      RUBY
    end

    # Redundant parentheses should be removed in another cop.
    define_method("test_does_not_register_offense_when_using_refute_with_#{matcher}_in_redundant_parentheses") do
      assert_no_offenses(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            refute((matcher.#{matcher}(string)))
          end
        end
      RUBY
    end
  end

  def test_registers_offense_when_using_refute_operator_with_match_operator
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_operator(matcher, :=~, object)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(matcher, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match(matcher, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_operator_with_mismatch_operator
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_operator(matcher, :!~, object)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(matcher, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match(matcher, object)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_match
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match(matcher, object)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_no_arguments_match_call
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(matcher.match)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_with_no_arguments_match_safe_navigation_call
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(matcher&.match)
        end
      end
    RUBY
  end

  def test_does_registers_offense_when_using_refute_operator_with_mismatch_operator
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_operator(matcher, :!~, :object)
        end
      end
    RUBY
  end

  def test_does_registers_offense_when_using_assert_operator_with_match_operator
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_operator(matcher, :=~, :object)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_neither_receiver_nor_first_argument_is_a_regexp_and_only_regexp_is_enabled
    enable_only_regexp

    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute matcher.match?(object)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_receiver_and_arguments_are_string_literals_and_only_regexp_is_enabled
    enable_only_regexp

    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute "...".match?("...")
        end
      end
    RUBY
  end

  def test_does_register_offense_when_receiver_is_a_regexp_literal_and_only_regexp_is_enabled
    enable_only_regexp

    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute /.../.match?(object)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(/.../, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match /.../, object
        end
      end
    RUBY
  end

  def test_does_register_offense_when_first_argument_is_a_regexp_literal_and_only_regexp_is_enabled
    enable_only_regexp

    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute object.match?(/.../)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_match(/.../, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_match /.../, object
        end
      end
    RUBY
  end

  private

  def enable_only_regexp
    @configuration = RuboCop::Config.new({ 'Minitest/RefuteMatch' => { 'OnlyRegexpLiteral' => true } })
  end
end
