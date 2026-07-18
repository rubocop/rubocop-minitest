# frozen_string_literal: true

# Laziness copied from rubocop source code
require 'rubocop/rspec/expect_offense'
require 'rubocop/cop/legacy/corrector'

module RuboCop
  module Minitest
    # Mixin for `assert_offense` and `assert_no_offenses`
    #
    # This mixin makes it easier to specify strict offense assertions
    # in a declarative and visual fashion. Just type out the code that
    # should generate an offense, annotate code by writing '^'s
    # underneath each character that should be highlighted, and follow
    # the carets with a string (separated by a space) that is the
    # message of the offense. You can include multiple offenses in
    # one code snippet.
    #
    # @example Usage
    #
    #   assert_offense(<<~RUBY)
    #     class FooTest < Minitest::Test
    #       def test_do_something
    #         assert_equal(nil, somestuff)
    #         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
    #       end
    #     end
    #   RUBY
    #
    # Autocorrection can be tested using `assert_correction` after
    # `assert_offense`.
    #
    # @example `assert_offense` and `assert_correction`
    #
    #   assert_offense(<<~RUBY)
    #     class FooTest < Minitest::Test
    #       def test_do_something
    #         assert_equal(nil, somestuff)
    #         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
    #       end
    #     end
    #   RUBY
    #
    #   assert_correction(<<~RUBY)
    #     class FooTest < Minitest::Test
    #       def test_do_something
    #         assert_nil(somestuff)
    #       end
    #     end
    #   RUBY
    #
    # If you do not want to specify an offense then use the
    # companion method `assert_no_offenses`. This method is a much
    # simpler assertion since it just inspects the source and checks
    # that there were no offenses. The `assert_offense` method has
    # to do more work by parsing out lines that contain carets.
    #
    # If the code produces an offense that could not be autocorrected, you can
    # use `assert_no_corrections` after `assert_offense`.
    #
    # @example `assert_offense` and `assert_no_corrections`
    #
    #   assert_offense(<<~RUBY)
    #     class FooTest < Minitest::Test
    #       def test_do_something
    #         assert_equal(nil, somestuff)
    #         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
    #       end
    #     end
    #   RUBY
    #
    #   assert_no_corrections
    #
    # The cop under test is derived from the test class name: `FooTest` resolves
    # the `Foo` constant in the test class's namespace, then `RuboCop::Cop::Minitest::Foo`.
    # Define a `cop_class` method in the test class to specify the cop explicitly:
    #
    #   class AssertNilTest < RuboCop::TestCase
    #     private
    #
    #     def cop_class
    #       RuboCop::Cop::Minitest::AssertNil
    #     end
    #   end
    #
    # The configuration for the cop under test and the target Ruby version can be specified
    # by overriding `cop_config`, `other_cops`, or `target_ruby_version` in the test class:
    #
    # @example `cop_config` and `target_ruby_version`
    #
    #   class MultipleAssertionsTest < RuboCop::TestCase
    #     private
    #
    #     def cop_config
    #       { 'Max' => 1 }
    #     end
    #
    #     def target_ruby_version
    #       3.0
    #     end
    #   end
    #
    # To change them for a single test, assign them in the test method.
    # This makes it possible for tests targeting different Ruby versions to live in the same test class:
    #
    # @example assigning `target_ruby_version` per test
    #
    #   class MyCopTest < RuboCop::TestCase
    #     def test_registers_offense_on_ruby31
    #       self.target_ruby_version = 3.1
    #
    #       assert_offense(<<~RUBY)
    #         ...
    #       RUBY
    #     end
    #
    #     def test_does_not_register_offense_on_ruby30
    #       self.target_ruby_version = 3.0
    #
    #       assert_no_offenses(<<~RUBY)
    #         ...
    #       RUBY
    #     end
    #   end
    #
    # rubocop:disable Metrics/ModuleLength
    module AssertOffense
      PLUGIN_INTEGRATION_MUTEX = Mutex.new
      private_constant :PLUGIN_INTEGRATION_MUTEX

      # Initialized here so that reading it under `ruby -w` does not warn before the first assignment.
      @integrated_plugins = nil

      class << self
        # Makes the default configuration of extensions registered as lint_roller plugins visible
        # through `RuboCop::ConfigLoader.default_configuration`.
        # Guarded by a mutex so that parallel test threads reaching their first assertion at the same time
        # do not integrate plugins twice or race on the lazy initialization of the default configuration.
        def integrate_plugins!
          PLUGIN_INTEGRATION_MUTEX.synchronize do
            next if @integrated_plugins

            plugins = Gem.loaded_specs.filter_map do |feature_name, feature_specification|
              feature_name if feature_specification.metadata['default_lint_roller_plugin']
            end
            RuboCop::Plugin.integrate_plugins(RuboCop::Config.new, plugins)

            @integrated_plugins = true
          end
        end
      end

      private

      def cop
        @cop ||= begin
          unless cop_class
            raise "Could not determine the cop class under test from `#{self.class}`. " \
                  'The cop class is derived from the test class name (e.g. `FooTest` resolves `Foo` ' \
                  "in the test class's namespace, then `RuboCop::Cop::Minitest::Foo`). " \
                  'Define a `cop_class` method in your test class to specify it explicitly.'
          end

          cop_class.new(configuration)
        end
      end

      def cop_class
        @cop_class ||= derive_cop_class
      end

      def cop_class=(cop_class)
        @cop_class = cop_class

        reset_memoization
      end

      def derive_cop_class
        klass = self.class

        while klass && klass != ::Minitest::Test
          candidate = derive_cop_class_from_name(klass.name)
          return candidate if candidate

          klass = klass.superclass
        end

        nil
      end

      def derive_cop_class_from_name(test_class_name)
        return unless test_class_name

        cop_name = test_class_name.delete_suffix('Test')
        return if cop_name.empty?

        constant_from(Object, cop_name) || constant_from(RuboCop::Cop::Minitest, cop_name.split('::').last)
      end

      def constant_from(namespace, constant_name)
        return unless namespace.const_defined?(constant_name)

        candidate = namespace.const_get(constant_name)

        candidate if candidate.is_a?(Class) && candidate < RuboCop::Cop::Base
      end

      def format_offense(source, **replacements)
        replacements.each do |keyword, value|
          value = value.to_s
          source = source.gsub("%{#{keyword}}", value)
                         .gsub("^{#{keyword}}", '^' * value.size)
                         .gsub("_{#{keyword}}", ' ' * value.size)
        end
        source
      end

      def assert_no_offenses(source, file = nil)
        setup_assertion

        offenses = inspect_source(source, file)

        expected_annotations = RuboCop::RSpec::ExpectOffense::AnnotatedSource.parse(source)
        actual_annotations = expected_annotations.with_offense_annotations(offenses)

        assert_equal(source, actual_annotations.to_s)
      end

      def assert_offense(source, file = nil, **replacements)
        setup_assertion
        enable_autocorrect

        source = format_offense(source, **replacements)
        expected_annotations = RuboCop::RSpec::ExpectOffense::AnnotatedSource.parse(source)
        if expected_annotations.plain_source == source
          raise 'Use `assert_no_offenses` to assert that no offenses are found'
        end

        @processed_source = parse_source!(expected_annotations.plain_source, file)

        @offenses = _investigate(cop, @processed_source)

        actual_annotations = expected_annotations.with_offense_annotations(@offenses)

        assert_equal(expected_annotations.to_s, actual_annotations.to_s)
      end

      def _investigate(cop, processed_source)
        team = RuboCop::Cop::Team.new([cop], configuration, raise_error: true)
        report = team.investigate(processed_source)
        @last_corrector = report.correctors.first || RuboCop::Cop::Corrector.new(processed_source)
        report.offenses
      end

      def enable_autocorrect
        cop.instance_variable_get(:@options)[:autocorrect] = true
      end

      def assert_correction(correction, loop: true)
        raise '`assert_correction` must follow `assert_offense`' unless @processed_source

        iteration = 0
        new_source = loop do
          iteration += 1

          corrected_source = @last_corrector.rewrite

          break corrected_source unless loop
          break corrected_source if @last_corrector.empty? || corrected_source == @processed_source.buffer.source

          if iteration > RuboCop::Runner::MAX_ITERATIONS
            raise RuboCop::Runner::InfiniteCorrectionLoop.new(@processed_source.path, [@offenses])
          end

          # Prepare for next loop
          @processed_source = parse_source!(corrected_source, @processed_source.path)

          _investigate(cop, @processed_source)
        end

        assert_equal(correction, new_source)
      end

      def assert_no_corrections
        raise '`assert_no_corrections` must follow `assert_offense`' unless @processed_source

        return if @last_corrector.empty?

        # This is just here for a pretty diff if the source actually got changed
        new_source = @last_corrector.rewrite

        assert_equal(@processed_source.buffer.source, new_source)

        # There is an infinite loop if a corrector is present that did not make
        # any changes. It will cause the same offense/correction on the next loop.
        raise RuboCop::Runner::InfiniteCorrectionLoop.new(@processed_source.path, [@offenses])
      end

      def setup_assertion
        RuboCop::Formatter::DisabledConfigFormatter.config_to_allow_offenses = {}
        RuboCop::Formatter::DisabledConfigFormatter.detected_styles = {}
      end

      def inspect_source(source, file = nil)
        processed_source = parse_source!(source, file)
        raise 'Error parsing example code' unless processed_source.valid_syntax?

        _investigate(cop, processed_source)
      end

      def investigate(processed_source)
        forces = Array(cop.class.joining_forces).map { |force_class| force_class.new([cop]) }

        commissioner = RuboCop::Cop::Commissioner.new([cop], forces, raise_error: true)
        commissioner.investigate(processed_source)
        commissioner
      end

      def parse_source!(source, file = nil)
        if file.respond_to?(:write)
          file.write(source)
          file.rewind
          file = file.path
        end

        processed_source = RuboCop::ProcessedSource.new(source, target_ruby_version, file, parser_engine: parser_engine)
        processed_source.config = configuration
        processed_source.registry = registry
        processed_source
      end

      def configuration
        @configuration ||= if defined?(config)
                             config
                           else
                             RuboCop::Config.new(configuration_hash, "#{Dir.pwd}/.rubocop.yml")
                           end
      end

      def configuration_hash
        RuboCop::Minitest::AssertOffense.integrate_plugins!

        hash = { 'AllCops' => { 'TargetRubyVersion' => target_ruby_version } }
        if cop_class
          hash[cop_class.cop_name] = RuboCop::ConfigLoader.default_configuration.for_cop(cop_class).merge(
            'Enabled' => true, 'AutoCorrect' => 'always'
          ).merge(cop_config)
        end

        hash.merge(other_cops)
      end

      def cop_config
        @cop_config ||= {}
      end

      def cop_config=(config)
        @cop_config = config

        reset_memoization
      end

      def other_cops
        @other_cops ||= {}
      end

      def other_cops=(other_cops)
        @other_cops = other_cops

        reset_memoization
      end

      def registry
        @registry ||= begin
          cops = configuration.keys.map { |cop| RuboCop::Cop::Registry.global.find_by_cop_name(cop) }
          cops << cop_class if cop_class && !cops.include?(cop_class)
          cops.compact!
          RuboCop::Cop::Registry.new(cops)
        end
      end

      def target_ruby_version
        # Prism is the default backend parser for Ruby 3.4+.
        @target_ruby_version ||= (ENV['PARSER_ENGINE'] == 'parser_prism' ? 3.4 : RuboCop::TargetRuby::DEFAULT_VERSION)
      end

      def target_ruby_version=(version)
        @target_ruby_version = version

        reset_memoization
      end

      def reset_memoization
        @cop = nil
        @configuration = nil
        @registry = nil
      end

      def ruby_version
        target_ruby_version
      end

      def parser_engine
        ENV.fetch('PARSER_ENGINE', :parser_whitequark).to_sym
      end
    end
    # rubocop:enable Metrics/ModuleLength
  end
end
