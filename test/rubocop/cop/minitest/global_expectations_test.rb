# frozen_string_literal: true

require_relative '../../../test_helper'

class GlobalExpectationsTest < Minitest::Test
  UNDERSCORE_ANY_STYLES = %i[_ any].freeze
  VALUE_ANY_STYLES = %i[value any].freeze
  EXPECT_ANY_STYLES = %i[expect any].freeze

  def setup
    configure_enforced_style(style)
  end

  def style
    :any
  end

  RuboCop::Cop::Minitest::GlobalExpectations::VALUE_MATCHERS.each do |matcher|
    define_method(:"test_registers_offense_when_using_global_#{matcher}") do
      assert_offense(<<~RUBY)
        it 'does something' do
          n.#{matcher} 42
          ^ Use `#{@preferred_method}(n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          #{@preferred_method}(n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_lvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          n = do_something
          n.#{matcher} 42
          ^ Use `#{@preferred_method}(n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          n = do_something
          #{@preferred_method}(n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_ivar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          @n = do_something
          @n.#{matcher} 42
          ^^ Use `#{@preferred_method}(@n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          @n = do_something
          #{@preferred_method}(@n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_cvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          @@n = do_something
          @@n.#{matcher} 42
          ^^^ Use `#{@preferred_method}(@@n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          @@n = do_something
          #{@preferred_method}(@@n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_gvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          $n = do_something
          $n.#{matcher} 42
          ^^ Use `#{@preferred_method}($n)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          $n = do_something
          #{@preferred_method}($n).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_hash_as_lvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          n = do_something
          n[:foo].#{matcher} 42
          ^^^^^^^ Use `#{@preferred_method}(n[:foo])` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          n = do_something
          #{@preferred_method}(n[:foo]).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_hash_as_ivar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          @n = do_something
          @n[:foo].#{matcher} 42
          ^^^^^^^^ Use `#{@preferred_method}(@n[:foo])` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          @n = do_something
          #{@preferred_method}(@n[:foo]).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_hash_as_cvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          @@n = do_something
          @@n[:foo].#{matcher} 42
          ^^^^^^^^^ Use `#{@preferred_method}(@@n[:foo])` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          @@n = do_something
          #{@preferred_method}(@@n[:foo]).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_hash_as_gvar") do
      assert_offense(<<~RUBY)
        it 'does something' do
          $n = do_something
          $n[:foo].#{matcher} 42
          ^^^^^^^^ Use `#{@preferred_method}($n[:foo])` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          $n = do_something
          #{@preferred_method}($n[:foo]).#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}") do
      if UNDERSCORE_ANY_STYLES.include?(style)
        assert_no_offenses(<<~RUBY)
          it 'does something' do
            _(n).#{matcher} 42
          end
        RUBY
      else
        assert_offense(<<~RUBY)
          it 'does something' do
            _(n).#{matcher} 42
            ^^^^ Use `#{@preferred_method}` instead.
          end
        RUBY

        assert_correction(<<~RUBY)
          it 'does something' do
            #{@preferred_method}(n).#{matcher} 42
          end
        RUBY
      end
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}_with_value_method") do
      if VALUE_ANY_STYLES.include?(style)
        assert_no_offenses(<<~RUBY)
          it 'does something' do
            value(n).#{matcher} 42
          end
        RUBY
      else
        assert_offense(<<~RUBY)
          it 'does something' do
            value(n).#{matcher} 42
            ^^^^^^^^ Use `#{@preferred_method}` instead.
          end
        RUBY

        assert_correction(<<~RUBY)
          it 'does something' do
            #{@preferred_method}(n).#{matcher} 42
          end
        RUBY
      end
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}_with_expect_method") do
      if EXPECT_ANY_STYLES.include?(style)
        assert_no_offenses(<<~RUBY)
          it 'does something' do
            expect(n).#{matcher} 42
          end
        RUBY
      else
        assert_offense(<<~RUBY)
          it 'does something' do
            expect(n).#{matcher} 42
            ^^^^^^^^^ Use `#{@preferred_method}` instead.
          end
        RUBY

        assert_correction(<<~RUBY)
          it 'does something' do
            #{@preferred_method}(n).#{matcher} 42
          end
        RUBY
      end
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_chained_hash_reference") do
      assert_offense(<<~RUBY)
        it 'does something' do
          options[:a][:b].#{matcher} 0
          ^^^^^^^^^^^^^^^ Use `#{@preferred_method}(options[:a][:b])` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          #{@preferred_method}(options[:a][:b]).#{matcher} 0
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_method_call_with_params") do
      assert_offense(<<~RUBY)
        it 'does something' do
          foo(a).#{matcher} 0
          ^^^^^^ Use `#{@preferred_method}(foo(a))` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          #{@preferred_method}(foo(a)).#{matcher} 0
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_for_constant") do
      assert_offense(<<~RUBY)
        it 'does something' do
          C.#{matcher}(:a)
          ^ Use `#{@preferred_method}(C)` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          #{@preferred_method}(C).#{matcher}(:a)
        end
      RUBY
    end
  end

  def test_works_with_chained_method_calls
    assert_offense(<<~RUBY)
      it 'does something' do
        A.foo.bar.must_equal 42
        ^^^^^^^^^ Use `#{@preferred_method}(A.foo.bar)` instead.
      end
    RUBY

    assert_correction(<<~RUBY)
      it 'does something' do
        #{@preferred_method}(A.foo.bar).must_equal 42
      end
    RUBY
  end

  RuboCop::Cop::Minitest::GlobalExpectations::BLOCK_MATCHERS.each do |matcher|
    define_method(:"test_registers_offense_when_using_global_#{matcher}") do
      assert_offense(<<~RUBY)
        it 'does something' do
          n.#{matcher} 42
          ^ Use `#{@preferred_method} { n }` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          #{@preferred_method} { n }.#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_registers_offense_when_using_global_#{matcher}_and_block") do
      assert_offense(<<~RUBY)
        it 'does something' do
          -> { n }.#{matcher} 42
          ^^^^^^^^ Use `#{@preferred_method} { n }` instead.
        end
      RUBY

      assert_correction(<<~RUBY)
        it 'does something' do
          #{@preferred_method} { n }.#{matcher} 42
        end
      RUBY
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}") do
      if UNDERSCORE_ANY_STYLES.include?(style)
        assert_no_offenses(<<~RUBY)
          it 'does something' do
            _(n).#{matcher} 42
          end
        RUBY
      else
        assert_offense(<<~RUBY)
          it 'does something' do
            _(n).#{matcher} 42
            ^^^^ Use `#{@preferred_method}` instead.
          end
        RUBY

        assert_correction(<<~RUBY)
          it 'does something' do
            #{@preferred_method}(n).#{matcher} 42
          end
        RUBY
      end
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}_with_block") do
      if UNDERSCORE_ANY_STYLES.include?(style)
        assert_no_offenses(<<~RUBY)
          it 'does something' do
            _ { n }.#{matcher} 42
          end
        RUBY
      else
        assert_offense(<<~RUBY)
          it 'does something' do
            _ { n }.#{matcher} 42
            ^^^^^^^ Use `#{@preferred_method}` instead.
          end
        RUBY

        assert_correction(<<~RUBY)
          it 'does something' do
            #{@preferred_method} { n }.#{matcher} 42
          end
        RUBY
      end
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}_with_value_method") do
      if VALUE_ANY_STYLES.include?(style)
        assert_no_offenses(<<~RUBY)
          it 'does something' do
            value(n).#{matcher} 42
          end
        RUBY
      else
        assert_offense(<<~RUBY)
          it 'does something' do
            value(n).#{matcher} 42
            ^^^^^^^^ Use `#{@preferred_method}` instead.
          end
        RUBY

        assert_correction(<<~RUBY)
          it 'does something' do
            #{@preferred_method}(n).#{matcher} 42
          end
        RUBY
      end
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}_with_expect_method") do
      if EXPECT_ANY_STYLES.include?(style)
        assert_no_offenses(<<~RUBY)
          it 'does something' do
            expect(n).#{matcher} 42
          end
        RUBY
      else
        assert_offense(<<~RUBY)
          it 'does something' do
            expect(n).#{matcher} 42
            ^^^^^^^^^ Use `#{@preferred_method}` instead.
          end
        RUBY

        assert_correction(<<~RUBY)
          it 'does something' do
            #{@preferred_method}(n).#{matcher} 42
          end
        RUBY
      end
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}_with_value_method_and_block") do
      if VALUE_ANY_STYLES.include?(style)
        assert_no_offenses(<<~RUBY)
          it 'does something' do
            value { n }.#{matcher} 42
          end
        RUBY
      else
        assert_offense(<<~RUBY)
          it 'does something' do
            value { n }.#{matcher} 42
            ^^^^^^^^^^^ Use `#{@preferred_method}` instead.
          end
        RUBY

        assert_correction(<<~RUBY)
          it 'does something' do
            #{@preferred_method} { n }.#{matcher} 42
          end
        RUBY
      end
    end

    define_method(:"test_no_offense_when_using_expect_form_of_#{matcher}_with_expect_method_and_block") do
      if EXPECT_ANY_STYLES.include?(style)
        assert_no_offenses(<<~RUBY)
          it 'does something' do
            expect { n }.#{matcher} 42
          end
        RUBY
      else
        assert_offense(<<~RUBY)
          it 'does something' do
            expect { n }.#{matcher} 42
            ^^^^^^^^^^^^ Use `#{@preferred_method}` instead.
          end
        RUBY

        assert_correction(<<~RUBY)
          it 'does something' do
            #{@preferred_method} { n }.#{matcher} 42
          end
        RUBY
      end
    end
  end

  def test_registers_offense_when_using_global_expectations_without_arguments
    assert_offense(<<~RUBY)
      it 'does something' do
        n.must_be_nil
        ^ Use `#{@preferred_method}(n)` instead.
      end
    RUBY

    assert_correction(<<~RUBY)
      it 'does something' do
        #{@preferred_method}(n).must_be_nil
      end
    RUBY
  end

  # Test Case: When PreferredMethod: _
  class WhenPreferredMethodUnderscore < self
    def style
      :_
    end
  end

  # Test Case: When PreferredMethod: expect
  class WhenPreferredMethodExpect < self
    def style
      :expect
    end
  end

  # Test Case: When PreferredMethod: value
  class WhenPreferredMethodValue < self
    def style
      :value
    end
  end

  private

  def configure_enforced_style(style)
    all_config = YAML.safe_load(File.read("#{__dir__}/../../../../config/default.yml")).freeze
    cop_config = all_config['Minitest/GlobalExpectations']
    cop_config = cop_config.merge('EnforcedStyle' => style)
    all_config = all_config.merge('Minitest/GlobalExpectations' => cop_config)
    config = RuboCop::Config.new(all_config)
    @cop = RuboCop::Cop::Minitest::GlobalExpectations.new(config)
    @preferred_method = style == :any ? :_ : style
  end
end
