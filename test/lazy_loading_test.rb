# frozen_string_literal: true

require_relative 'test_helper'
require 'tmpdir'

class LazyLoadingTest < Minitest::Test
  def test_cops_are_registered_without_loading_their_files
    output = run_script(<<~RUBY)
      require 'rubocop-minitest'

      registry = RuboCop::Cop::Registry.global
      loaded_cop_files = $LOADED_FEATURES.grep(%r{/rubocop/cop/minitest/})
      loaded_mixin_files = $LOADED_FEATURES.grep(%r{\#{Regexp.escape('#{lib_dir}')}/rubocop/cop/mixin/})

      puts "registered=\#{registry.names.grep(%r{\\AMinitest/}).size}"
      puts "loaded_cop_files=\#{loaded_cop_files.size}"
      puts "loaded_mixin_files=\#{loaded_mixin_files.size}"
    RUBY

    assert_includes(output, 'registered=56')
    assert_includes(output, 'loaded_cop_files=0')
    assert_includes(output, 'loaded_mixin_files=0')
  end

  def test_mixins_are_autoloaded_when_a_cop_class_is_loaded
    output = run_script(<<~RUBY)
      require 'rubocop-minitest'

      assert_empty_cop = RuboCop::Cop::Registry.global.find_by_cop_name('Minitest/AssertEmpty')
      assert_nil_cop = RuboCop::Cop::Registry.global.find_by_cop_name('Minitest/AssertNil')
      loaded_mixin_files = $LOADED_FEATURES.grep(%r{\#{Regexp.escape('#{lib_dir}')}/rubocop/cop/mixin/})

      puts "define_rule_applied=\#{assert_empty_cop.include?(RuboCop::Cop::ArgumentRangeHelper) &&
        assert_empty_cop.singleton_class.include?(RuboCop::Cop::MinitestCopRule)}"
      puts "minitest_mixin_applied=\#{assert_nil_cop.include?(RuboCop::Cop::Minitest::NilAssertionHandleable)}"
      puts "loaded_mixin_files=\#{loaded_mixin_files.map { |path| File.basename(path) }.sort.join(',')}"
    RUBY

    assert_includes(output, 'define_rule_applied=true')
    assert_includes(output, 'minitest_mixin_applied=true')
    expected_mixin_files = 'argument_range_helper.rb,minitest_cop_rule.rb,nil_assertion_handleable.rb'
    assert_includes(output, "loaded_mixin_files=#{expected_mixin_files}")
  end

  def test_a_cop_is_not_registered_twice_when_its_file_is_required_directly
    output = run_script(<<~RUBY)
      require 'rubocop-minitest'

      before = RuboCop::Cop::Registry.global.length
      require 'rubocop/cop/minitest/assert_empty'
      after = RuboCop::Cop::Registry.global.length

      puts "stable=\#{before == after}"
      puts "class=\#{RuboCop::Cop::Registry.global.find_by_cop_name('Minitest/AssertEmpty')}"
    RUBY

    assert_includes(output, 'stable=true')
    assert_includes(output, 'class=RuboCop::Cop::Minitest::AssertEmpty')
  end

  private

  def run_script(source)
    Dir.mktmpdir do |dir|
      script = File.join(dir, 'script.rb')
      File.write(script, source)
      output = `#{RbConfig.ruby} -I #{lib_dir} #{script} 2>&1`
      raise "script failed:\n#{output}" unless $CHILD_STATUS.success?

      output
    end
  end

  def lib_dir
    File.expand_path('../lib', __dir__)
  end
end
