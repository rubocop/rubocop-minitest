# frozen_string_literal: true

# Require this file to load code that supports testing using Minitest.
# rubocop:disable Metrics/ClassLength

require 'rubocop'
require 'rubocop/rspec/expect_offense'
require 'rubocop/cop/legacy/corrector'

module RuboCop
  module Minitest
    # Minitest base test class that adds `assert_offense` and `assert_no_offenses`
    #
    # This test class makes it easier to specify strict offense assertions
    # in a declarative and visual fashion. Just type out the code that
    # should generate an offense, annotate code by writing '^'s
    # underneath each character that should be highlighted, and follow
    # the carets with a string (separated by a space) that is the
    # message of the offense. You can include multiple offenses in
    # one code snippet.
    #
    # @example Usage
    #
    #   class AssertNilTest < RuboCop::Minitest::Test
    #     def test_fails_when_using_assert_equal_nil
    #       assert_offense(<<~RUBY)
    #         class FooTest < Minitest::Test
    #           def test_do_something
    #             assert_equal(nil, somestuff)
    #             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
    #           end
    #         end
    #       RUBY
    #     end
    #   end
    #
    # Autocorrection can be tested using `assert_correction` after
    # `assert_offense`.
    #
    # @example `assert_offense` and `assert_correction`
    #
    #   class AssertNilTest < RuboCop::Minitest::Test
    #      def test_autocorrects_when_using_assert_equal
    #        assert_offense(<<~RUBY)
    #          class FooTest < Minitest::Test
    #           def test_do_something
    #             assert_equal(nil, somestuff)
    #             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
    #           end
    #         RUBY
    #
    #         assert_correction(<<~RUBY)
    #           class FooTest < Minitest::Test
    #             def test_do_something
    #               assert_nil(somestuff)
    #             end
    #           end
    #         RUBY
    #       end
    #     end
    #   end
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
    #   class AssertNilTest < RuboCop::Minitest::Test
    #     def test_no_autocorrections
    #       assert_offense(<<~RUBY)
    #         class FooTest < Minitest::Test
    #           def test_do_something
    #             assert_equal(nil, somestuff)
    #             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
    #           end
    #         end
    #       RUBY
    #
    #       assert_no_corrections
    #     end
    #   end
    class Test < ::Minitest::Test
      private

      def setup
        cop_name = self.class.to_s.delete_suffix('Test')

        cop_class = begin
          Object.const_get("RuboCop::Cop::Minitest::#{cop_name}")
        rescue NameError # rubocop:disable Lint/SuppressedException
        end

        cop_class ||= begin
          Object.const_get(cop_name)
        rescue NameError # rubocop:disable Lint/SuppressedException
        end

        @cop = cop_class.new(configuration) if cop_class&.ancestors&.include?(RuboCop::Cop::Base)
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

        offenses = inspect_source(source, @cop, file)

        expected_annotations = RuboCop::RSpec::ExpectOffense::AnnotatedSource.parse(source)
        actual_annotations = expected_annotations.with_offense_annotations(offenses)

        assert_equal(source, actual_annotations.to_s)
      end

      def assert_offense(source, file = nil, **replacements)
        setup_assertion

        @cop.instance_variable_get(:@options)[:autocorrect] = true

        source = format_offense(source, **replacements)
        expected_annotations = RuboCop::RSpec::ExpectOffense::AnnotatedSource.parse(source)
        if expected_annotations.plain_source == source
          raise 'Use `assert_no_offenses` to assert that no offenses are found'
        end

        @processed_source = parse_source!(expected_annotations.plain_source, file)

        offenses = _investigate(@cop, @processed_source)

        actual_annotations = expected_annotations.with_offense_annotations(offenses)

        assert_equal(expected_annotations.to_s, actual_annotations.to_s)
      end

      def _investigate(cop, processed_source)
        team = RuboCop::Cop::Team.new([cop], configuration, raise_error: true)
        report = team.investigate(processed_source)
        @last_corrector = report.correctors.first || RuboCop::Cop::Corrector.new(processed_source)
        report.offenses
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
            raise RuboCop::Runner::InfiniteCorrectionLoop.new(@processed_source.path, [])
          end

          # Prepare for next loop
          @processed_source = parse_source!(corrected_source, @processed_source.path)

          _investigate(@cop, @processed_source)
        end

        assert_equal(correction, new_source)
      end

      def setup_assertion
        RuboCop::Formatter::DisabledConfigFormatter.config_to_allow_offenses = {}
        RuboCop::Formatter::DisabledConfigFormatter.detected_styles = {}
        raise('Could not autodetect cop.') if @cop.nil?
      end

      def inspect_source(source, cop, file = nil)
        processed_source = parse_source!(source, file)
        raise 'Error parsing example code' unless processed_source.valid_syntax?

        _investigate(cop, processed_source)
      end

      def investigate(cop, processed_source)
        needed = Hash.new { |h, k| h[k] = [] }
        Array(cop.class.joining_forces).each { |force| needed[force] << cop }
        forces = needed.map do |force_class, joining_cops|
          force_class.new(joining_cops)
        end

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

        processed_source = RuboCop::ProcessedSource.new(source, ruby_version, file)

        # Follow up https://github.com/rubocop/rubocop/pull/10987.
        # When support for RuboCop 1.37.1 ends, this condition can be removed.
        if processed_source.respond_to?(:config) && processed_source.respond_to?(:registry)
          processed_source.config = configuration
          processed_source.registry = registry
        end

        processed_source
      end

      def configuration
        @configuration ||= if defined?(config)
                             config
                           else
                             RuboCop::Config.new({}, "#{Dir.pwd}/.rubocop.yml")
                           end
      end

      def registry
        @registry ||= begin
          cops = configuration.keys.map { |cop| RuboCop::Cop::Registry.global.find_by_cop_name(cop) }
          cops << cop_class if defined?(cop_class) && !cops.include?(cop_class)
          cops.compact!
          RuboCop::Cop::Registry.new(cops)
        end
      end

      def ruby_version
        RuboCop::TargetRuby::DEFAULT_VERSION
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
