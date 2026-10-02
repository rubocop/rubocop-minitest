# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertIncludesTest < RuboCop::TestCase
  def test_registers_offense_when_using_assert_with_include
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.include?(object))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(collection, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(collection, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_member
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.member?(object))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(collection, object)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(collection, object)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_include_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.include?(object), 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(collection, object, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(collection, object, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_with_include_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.include?(object), <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(collection, object, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(collection, object, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  # Redundant parentheses should be removed by `Style/RedundantParentheses` cop.
  def test_does_not_register_offense_when_using_assert_with_include_in_redundant_parentheses
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert((collection.include?(object)))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_includes_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(collection, object)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_with_non_include_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.end_with?(string))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_with_local_variable
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          collection = []
          assert(collection)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_with_key
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.key?(object))
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_with_has_key
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert(collection.has_key?(object))
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_match_with_simple_string_regexp
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/foo/, 'foobar')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes('foobar', 'foo')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes('foobar', 'foo')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_match_with_simple_string_regexp_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/foo/, 'foobar', 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes('foobar', 'foo', 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes('foobar', 'foo', 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_match_with_escaped_url
    assert_offense(<<~'RUBY')
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/http:\/\/example\.com/, response.body)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(response.body, 'http://example.com')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(response.body, 'http://example.com')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_match_with_anchor
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/^foo/, 'foobar')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_match_with_end_anchor
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/foo$/, 'foobar')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_match_with_character_class
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/fo[ob]/, 'foobar') # codespell:ignore
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_match_with_quantifier
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/foo+/, 'foobar')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_match_with_alternation
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/foo|bar/, 'foobar')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_match_with_metacharacter
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/foo.bar/, 'foobar')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_match_with_interpolation
    assert_no_offenses(<<~'RUBY')
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/foo-#{bar}/, 'foobar')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_match_with_regex_options
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/foo/x, 'foobar')
          assert_match(/foo/i, 'foobar')
          assert_match(/foo/m, 'foobar')
          assert_match(/foo/n, 'foobar')
          assert_match(/foo/u, 'foobar')
          assert_match(/foo/o, 'foobar')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_assert_match_with_string_containing_both_quotes
    assert_offense(<<~'RUBY')
      class FooTest < Minitest::Test
        def test_do_something
          assert_match(/it's "working"/, response)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_includes(response, "it's \"working\"")`.
        end
      end
    RUBY

    assert_correction(<<~'RUBY')
      class FooTest < Minitest::Test
        def test_do_something
          assert_includes(response, "it's \"working\"")
        end
      end
    RUBY
  end
end
