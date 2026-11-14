# frozen_string_literal: true

require_relative '../../../test_helper'

class ExpectationImplicitHashTest < Minitest::Test
  %i[must_equal wont_equal must_be_same_as wont_be_same_as].each do |matcher|
    define_method("test_registers_offense_when_using_implicit_hash_with_#{matcher}") do
      assert_offense(<<~RUBY, matcher: matcher)
        _(actual).%{matcher}(a: 1)
                  _{matcher} ^^^^ Wrap the expected hash in braces; without them, it is passed as keyword arguments.
      RUBY

      assert_correction(<<~RUBY)
        _(actual).#{matcher}({a: 1})
      RUBY
    end
  end

  def test_registers_offense_when_using_implicit_hash_with_expect
    assert_offense(<<~RUBY)
      expect(actual).must_equal(a: 1, b: 2)
                                ^^^^^^^^^^ Wrap the expected hash in braces; without them, it is passed as keyword arguments.
    RUBY

    assert_correction(<<~RUBY)
      expect(actual).must_equal({a: 1, b: 2})
    RUBY
  end

  def test_registers_offense_when_using_implicit_hash_with_value
    assert_offense(<<~RUBY)
      value(actual).must_equal('a' => 1)
                               ^^^^^^^^ Wrap the expected hash in braces; without them, it is passed as keyword arguments.
    RUBY

    assert_correction(<<~RUBY)
      value(actual).must_equal({'a' => 1})
    RUBY
  end

  def test_registers_offense_when_using_implicit_hash_with_global_expectation
    assert_offense(<<~RUBY)
      actual.must_equal(a: 1)
                        ^^^^ Wrap the expected hash in braces; without them, it is passed as keyword arguments.
    RUBY

    assert_correction(<<~RUBY)
      actual.must_equal({a: 1})
    RUBY
  end

  def test_registers_offense_when_using_implicit_hash_with_safe_navigation
    assert_offense(<<~RUBY)
      _(actual)&.must_equal(a: 1)
                            ^^^^ Wrap the expected hash in braces; without them, it is passed as keyword arguments.
    RUBY

    assert_correction(<<~RUBY)
      _(actual)&.must_equal({a: 1})
    RUBY
  end

  def test_registers_offense_when_using_implicit_hash_without_parentheses
    assert_offense(<<~RUBY)
      _(actual).must_equal a: 1, b: 2
                           ^^^^^^^^^^ Wrap the expected hash in braces; without them, it is passed as keyword arguments.
    RUBY

    assert_correction(<<~RUBY)
      _(actual).must_equal({a: 1, b: 2})
    RUBY
  end

  def test_registers_offense_when_using_multiline_implicit_hash
    assert_offense(<<~RUBY)
      _(actual).must_equal(
        a: 1,
        ^^^^^ Wrap the expected hash in braces; without them, it is passed as keyword arguments.
        b: 2
      )
    RUBY

    assert_correction(<<~RUBY)
      _(actual).must_equal(
        {a: 1,
        b: 2}
      )
    RUBY
  end

  def test_registers_offense_when_using_implicit_hash_with_pairs_and_double_splat
    assert_offense(<<~RUBY)
      _(actual).must_equal(a: 1, **other)
                           ^^^^^^^^^^^^^ Wrap the expected hash in braces; without them, it is passed as keyword arguments.
    RUBY

    assert_correction(<<~RUBY)
      _(actual).must_equal({a: 1, **other})
    RUBY
  end

  def test_registers_offense_when_using_multiple_double_splats
    assert_offense(<<~RUBY)
      _(actual).must_equal(**one, **other)
                           ^^^^^^^^^^^^^^ Wrap the expected hash in braces; without them, it is passed as keyword arguments.
    RUBY

    assert_correction(<<~RUBY)
      _(actual).must_equal({**one, **other})
    RUBY
  end

  def test_registers_offense_when_using_double_splat
    assert_offense(<<~RUBY)
      _(actual).must_equal(**expected)
                           ^^^^^^^^^^ Pass the expected hash without `**`; with it, it is passed as keyword arguments.
    RUBY

    assert_correction(<<~RUBY)
      _(actual).must_equal(expected)
    RUBY
  end

  def test_registers_offense_when_using_double_splat_without_parentheses
    assert_offense(<<~RUBY)
      _(actual).wont_equal **expected
                           ^^^^^^^^^^ Pass the expected hash without `**`; with it, it is passed as keyword arguments.
    RUBY

    assert_correction(<<~RUBY)
      _(actual).wont_equal expected
    RUBY
  end

  def test_does_not_register_offense_when_using_explicit_hash
    assert_no_offenses(<<~RUBY)
      _(actual).must_equal({a: 1})
    RUBY
  end

  def test_does_not_register_offense_when_using_variable
    assert_no_offenses(<<~RUBY)
      _(actual).must_equal(expected)
    RUBY
  end

  def test_does_not_register_offense_when_implicit_hash_follows_expected_value
    assert_no_offenses(<<~RUBY)
      _(actual).must_equal(expected, a: 1)
    RUBY
  end

  def test_does_not_register_offense_when_using_block_pass
    assert_no_offenses(<<~RUBY)
      _(actual).must_equal(a: 1, &block)
    RUBY
  end

  def test_does_not_register_offense_when_using_other_matcher
    assert_no_offenses(<<~RUBY)
      _(actual).must_respond_to(:foo, include_all: true)
    RUBY
  end

  def test_does_not_register_offense_without_receiver
    assert_no_offenses(<<~RUBY)
      must_equal(a: 1)
    RUBY
  end
end
