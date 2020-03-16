# frozen_string_literal: true

require 'test_helper'

class GlobalExpectationsTest < Minitest::Test
  RuboCop::Cop::Minitest::GlobalExpectations::VALUE_MATCHERS.each do |matcher|
    define_method(:"test_registers_offense_when_using_global_#{matcher}") do
      assert_offense(<<~RUBY)
        it 'does something' do
          n.#{matcher} 42
          ^ Use `_(n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          _(n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_lvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          n = do_something
          n.#{matcher} 42
          ^ Use `_(n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          n = do_something
          _(n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_ivar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          @n = do_something
          @n.#{matcher} 42
          ^^ Use `_(@n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          @n = do_something
          _(@n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_cvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          @@n = do_something
          @@n.#{matcher} 42
          ^^^ Use `_(@@n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          @@n = do_something
          _(@@n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_gvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          $n = do_something
          $n.#{matcher} 42
          ^^ Use `_($n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          $n = do_something
          _($n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_hash_as_lvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          n = do_something
          n[:foo].#{matcher} 42
          ^^^^^^^ Use `_(n[:foo])` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          n = do_something
          _(n[:foo]).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_hash_as_ivar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          @n = do_something
          @n[:foo].#{matcher} 42
          ^^^^^^^^ Use `_(@n[:foo])` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          @n = do_something
          _(@n[:foo]).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_hash_as_cvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          @@n = do_something
          @@n[:foo].#{matcher} 42
          ^^^^^^^^^ Use `_(@@n[:foo])` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          @@n = do_something
          _(@@n[:foo]).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_hash_as_gvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          $n = do_something
          $n[:foo].#{matcher} 42
          ^^^^^^^^ Use `_($n[:foo])` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          $n = do_something
          _($n[:foo]).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}") do
      assert_no_offenses(<<~RUBY)
        it 'does something' do
          _(n).#{matcher} 42
        end
      RUBY
    end
  end

  def test_works_with_chained_method_calls
    assert_offense(<<~RUBY)
      it 'does something' do
        A.foo.bar.must_equal 42
        ^^^^^^^^^ Use `_(A.foo.bar)` instead.
      end
    RUBY

    assert_correction(<<~RUBY)
      it 'does something' do
        _(A.foo.bar).must_equal 42
      end
    RUBY
  end

  RuboCop::Cop::Minitest::GlobalExpectations::BLOCK_MATCHERS.each do |matcher|
    define_method(:"test_registers_offense_when_using_global_#{matcher}") do
      assert_offense(<<~RUBY)
        it 'does something' do
          n.#{matcher} 42
          ^ Use `_ { n }` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          _ { n }.#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}") do
      assert_no_offenses(<<~RUBY)
        it 'does something' do
          _ { n }.#{matcher} 42
        end
      RUBY
    end
  end
end
