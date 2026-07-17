# frozen_string_literal: true

require_relative '../test_helper'

module CustomCops
  class UseFoo < RuboCop::Cop::Base
    extend RuboCop::Cop::AutoCorrector

    MSG = 'Use `foo` instead of `bar`.'

    def on_send(node)
      return unless node.method?(:bar)

      add_offense(node) do |corrector|
        corrector.replace(node, 'foo')
      end
    end
  end

  class UseFooTest < RuboCop::TestCase
    def test_derives_cop_class_from_test_class_namespace
      assert_equal(CustomCops::UseFoo, cop_class)
    end

    def test_registers_offense_and_corrects
      assert_offense(<<~RUBY)
        bar
        ^^^ Use `foo` instead of `bar`.
      RUBY

      assert_correction(<<~RUBY)
        foo
      RUBY
    end

    def test_inspect_source_uses_the_cop_under_test
      offenses = inspect_source('bar')

      assert_equal(1, offenses.size)
      assert_equal('Use `foo` instead of `bar`.', offenses.first.message)
    end

    def test_inspect_source_accepts_file_path
      offenses = inspect_source('bar', 'lib/example.rb')

      assert_equal(1, offenses.size)
    end
  end
end

class RuboCopTestCaseCopResolutionTest < RuboCop::TestCase
  def test_resolves_namespaced_cop_from_test_class_name
    assert_equal(CustomCops::UseFoo, derive_cop_class_from_name('CustomCops::UseFooTest'))
  end

  def test_falls_back_to_rubocop_cop_minitest_namespace
    assert_equal(RuboCop::Cop::Minitest::AssertNil, derive_cop_class_from_name('AssertNilTest'))
  end

  def test_does_not_resolve_constants_that_are_not_cops
    assert_nil(derive_cop_class_from_name('CustomCopsTest'))
  end
end

class RuboCopTestCaseUnresolvableCopTest < RuboCop::TestCase
  def test_raises_helpful_error_when_cop_class_cannot_be_derived
    error = assert_raises(RuntimeError) { cop }

    assert_includes(error.message, 'Define a `cop_class` method in your test class')
  end
end

class RuboCopTestCaseConfigurationTest < RuboCop::TestCase
  def test_assigning_cop_config_configures_the_cop
    self.cop_config = { 'Max' => 1 }

    assert_equal(1, cop.cop_config['Max'])
  end

  def test_assigning_cop_config_resets_the_memoized_cop
    assert_equal(3, cop.cop_config['Max'])

    self.cop_config = { 'Max' => 1 }

    assert_equal(1, cop.cop_config['Max'])
  end

  def test_default_configuration_is_merged_into_cop_config
    assert_equal(3, cop.cop_config['Max'])
  end

  private

  def cop_class
    RuboCop::Cop::Minitest::MultipleAssertions
  end
end

class RuboCopTestCaseTargetRubyVersionTest < RuboCop::TestCase
  def test_target_ruby_version_flows_into_parser_and_configuration
    processed_source = parse_source!('bar')

    assert_in_delta(3.4, processed_source.ruby_version)
    assert_in_delta(3.4, configuration.target_ruby_version)
  end

  private

  def cop_class
    CustomCops::UseFoo
  end

  def target_ruby_version
    3.4
  end
end

# Assigning `target_ruby_version` per test is safe under multithreaded
# parallel execution because all state lives in the per-test instance.
# Ruby 3.3 and 3.4 are used here because Prism supports parsing Ruby 3.3+.
class RuboCopTestCaseParallelExecutionTest < RuboCop::TestCase
  parallelize_me!

  (1..4).each do |i|
    define_method(:"test_parses_with_ruby33_variant#{i}") do
      self.target_ruby_version = 3.3

      processed_source = parse_source!('bar')

      assert_in_delta(3.3, processed_source.ruby_version)
      assert_in_delta(3.3, configuration.target_ruby_version)
    end

    define_method(:"test_parses_with_ruby34_variant#{i}") do
      self.target_ruby_version = 3.4

      processed_source = parse_source!('bar')

      assert_in_delta(3.4, processed_source.ruby_version)
      assert_in_delta(3.4, configuration.target_ruby_version)
    end

    define_method(:"test_registers_offense_variant#{i}") do
      self.target_ruby_version = 3.4

      assert_offense(<<~RUBY)
        bar
        ^^^ Use `foo` instead of `bar`.
      RUBY
    end
  end

  private

  def cop_class
    CustomCops::UseFoo
  end
end

# Tests targeting different Ruby versions can live in the same test class
# by assigning `target_ruby_version` per test. Ruby 3.3 and 3.4 are used
# here because Prism supports parsing Ruby 3.3+.
class RuboCopTestCasePerTestTargetRubyVersionTest < RuboCop::TestCase
  def test_parses_with_ruby33
    self.target_ruby_version = 3.3

    processed_source = parse_source!('bar')

    assert_in_delta(3.3, processed_source.ruby_version)
    assert_in_delta(3.3, configuration.target_ruby_version)
  end

  def test_parses_with_ruby34
    self.target_ruby_version = 3.4

    processed_source = parse_source!('bar')

    assert_in_delta(3.4, processed_source.ruby_version)
    assert_in_delta(3.4, configuration.target_ruby_version)
  end

  def test_assigning_target_ruby_version_resets_the_memoized_configuration
    self.target_ruby_version = 3.3

    assert_in_delta(3.3, configuration.target_ruby_version)

    self.target_ruby_version = 3.4

    assert_in_delta(3.4, configuration.target_ruby_version)
  end

  private

  def cop_class
    CustomCops::UseFoo
  end
end
