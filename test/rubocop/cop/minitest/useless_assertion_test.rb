# frozen_string_literal: true

require_relative '../../../test_helper'

class UselessAssertionTest < RuboCop::Minitest::Test
  %i[assert refute assert_nil refute_nil assert_not assert_empty refute_empty].each do |matcher|
    define_method("test_#{matcher}_registers_offense_when_using_literals") do
      assert_offense(<<~RUBY, matcher: matcher)
        #{matcher} []
        ^{matcher}^^^ Useless assertion detected.
        #{matcher} [foo]
        ^{matcher}^^^^^^ Useless assertion detected.

        #{matcher}({})
        ^{matcher}^^^^ Useless assertion detected.
        #{matcher}({ key: value })
        ^{matcher}^^^^^^^^^^^^^^^^ Useless assertion detected.

        #{matcher} nil
        ^{matcher}^^^^ Useless assertion detected.
        #{matcher} true
        ^{matcher}^^^^^ Useless assertion detected.
        #{matcher} false
        ^{matcher}^^^^^^ Useless assertion detected.

        #{matcher} ""
        ^{matcher}^^^ Useless assertion detected.
        #{matcher} "foo"
        ^{matcher}^^^^^^ Useless assertion detected.

        #{matcher} 1
        ^{matcher}^^ Useless assertion detected.
      RUBY
    end

    define_method("test_#{matcher}_no_offenses_when_using_method_call") do
      assert_no_offenses(<<~RUBY)
        #{matcher} foo
      RUBY
    end

    define_method("test_#{matcher}_no_offenses_when_using_explicit_message") do
      assert_no_offenses(<<~RUBY)
        #{matcher} false, "My message"
      RUBY
    end

    define_method("test_#{matcher}_no_offenses_when_executing_command") do
      assert_no_offenses(<<~RUBY)
        #{matcher} `ls`
        #{matcher} %x{ls}
      RUBY
    end
  end

  %i[
    assert_equal refute_equal
    assert_in_delta refute_in_delta
    assert_in_epsilon refute_in_epsilon
    assert_same refute_same
  ].each do |matcher|
    define_method("test_#{matcher}_registers_offense_when_using_same_expected_and_actual") do
      assert_offense(<<~RUBY, matcher: matcher)
        #{matcher} [], []
        ^{matcher}^^^^^^^ Useless assertion detected.
        #{matcher} $foo, $foo
        ^{matcher}^^^^^^^^^^^ Useless assertion detected.
      RUBY
    end

    define_method("test_#{matcher}_registers_offense_when_using_same_local_variable") do
      assert_offense(<<~RUBY, matcher: matcher)
        foo = get_foo
        #{matcher} foo, foo
        ^{matcher}^^^^^^^^^ Useless assertion detected.
      RUBY
    end

    define_method("test_#{matcher}_no_offenses_when_different_expected_and_actual") do
      assert_no_offenses(<<~RUBY)
        #{matcher} foo, bar
      RUBY
    end

    define_method("test_#{matcher}_no_offenses_when_expected_and_actual_are_same_method_call") do
      assert_no_offenses(<<~RUBY)
        #{matcher} foo, foo
      RUBY
    end

    define_method("test_#{matcher}_no_offenses_when_expected_and_actual_are_same_expression") do
      assert_no_offenses(<<~RUBY)
        #{matcher} x.foo, x.foo
      RUBY
    end

    define_method("test_#{matcher}_no_offense_when_only_single_argument_is_given") do
      assert_no_offenses(<<~RUBY)
        #{matcher} foo
      RUBY
    end
  end

  %i[assert_includes refute_includes].each do |matcher|
    define_method("test_#{matcher}_registers_offense_when_using_empty_hash") do
      assert_offense(<<~RUBY, matcher: matcher)
        #{matcher}({}, foo)
        ^{matcher}^^^^^^^^^ Useless assertion detected.
      RUBY
    end

    define_method("test_#{matcher}_registers_offense_when_using_empty_array") do
      assert_offense(<<~RUBY, matcher: matcher)
        #{matcher} [], foo
        ^{matcher}^^^^^^^^ Useless assertion detected.
      RUBY
    end

    define_method("test_#{matcher}_registers_offense_when_using_empty_string") do
      assert_offense(<<~RUBY, matcher: matcher)
        #{matcher} "", foo
        ^{matcher}^^^^^^^^ Useless assertion detected.
      RUBY
    end

    define_method("test_#{matcher}_no_offenses_when_using_non_empty_composite_literal") do
      assert_no_offenses(<<~RUBY)
        #{matcher} foo, bar
      RUBY
    end

    define_method("test_#{matcher}_no_offenses_when_using_method_call") do
      assert_no_offenses(<<~RUBY)
        #{matcher} foo, bar
      RUBY
    end
  end

  def test_assert_silent_registers_offense_when_block_is_empty
    assert_offense(<<~RUBY)
      assert_silent {}
      ^^^^^^^^^^^^^ Useless assertion detected.
    RUBY
  end

  def test_assert_silent_no_offenses_when_block_has_a_body
    assert_no_offenses(<<~RUBY)
      assert_silent do
        foo
      end
    RUBY
  end

  def test_ignores_useless_assertion_called_on_receiver
    assert_no_offenses(<<~RUBY)
      foo.assert(true)
    RUBY
  end
end
