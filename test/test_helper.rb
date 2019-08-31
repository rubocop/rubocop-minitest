# frozen_string_literal: true

require 'rubocop'
require 'rubocop-minitest'
require 'minitest/autorun'
require 'minitest/pride'

# Laziness copied from rubocop source code
require 'rubocop/rspec/expect_offense'

private

# rubocop:disable all
def assert_offense(source, cop, file = nil)
  RuboCop::Formatter::DisabledConfigFormatter
    .config_to_allow_offenses = {}
  RuboCop::Formatter::DisabledConfigFormatter.detected_styles = {}
  cop.instance_variable_get(:@options)[:auto_correct] = true
  expected_annotations = RuboCop::RSpec::ExpectOffense::AnnotatedSource.parse(source)
  if expected_annotations.plain_source == source
    raise 'Use `assert_no_offenses` to assert that no offenses are found'
  end

  @processed_source = parse_source(expected_annotations.plain_source,
                                   file)
  unless @processed_source.valid_syntax?
   raise 'Error parsing example code'
  end
  _investigate(cop, @processed_source)
  actual_annotations =
    expected_annotations.with_offense_annotations(cop.offenses)

  assert_equal(expected_annotations.to_s, actual_annotations.to_s)
end

def assert_correction(correction, cop)
  unless @processed_source
    raise '`expect_correction` must follow `expect_offense`'
  end

  corrector =
    RuboCop::Cop::Corrector.new(@processed_source.buffer, cop.corrections)
  new_source = corrector.rewrite

  assert_equal(correction, new_source)
end

def assert_no_offenses(source, cop, file = nil)
  inspect_source(source, cop, file)

  expected_annotations = RuboCop::RSpec::ExpectOffense::AnnotatedSource.parse(source)
  actual_annotations =
    expected_annotations.with_offense_annotations(cop.offenses)
  assert_equal(source, actual_annotations.to_s)
end

def inspect_source(source, cop, file = nil)
  RuboCop::Formatter::DisabledConfigFormatter.config_to_allow_offenses = {}
  RuboCop::Formatter::DisabledConfigFormatter.detected_styles = {}
  processed_source = parse_source(source, file)
  raise 'Error parsing example code' unless processed_source.valid_syntax?

  _investigate(cop, processed_source)
end

def _investigate(cop, processed_source)
  forces = RuboCop::Cop::Force.all.each_with_object([]) do |klass, instances|
    next unless cop.join_force?(klass)

    instances << klass.new([cop])
  end

  commissioner =
    RuboCop::Cop::Commissioner.new([cop], forces, raise_error: true)
  commissioner.investigate(processed_source)
  commissioner
end

def parse_source(source, file = nil)
  if file&.respond_to?(:write)
    file.write(source)
    file.rewind
    file = file.path
  end

  RuboCop::ProcessedSource.new(source, 2.3, file)
end
# rubocop:enable all
