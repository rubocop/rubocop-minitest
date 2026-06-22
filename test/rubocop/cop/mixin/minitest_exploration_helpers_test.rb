# frozen_string_literal: true

require_relative '../../../test_helper'

class MinitestExplorationHelpersTest < Minitest::Test
  module Helper
    extend RuboCop::Cop::MinitestExplorationHelpers

    class << self
      public :test_case?, :test_class?, :test_base_classes
    end
  end

  SOURCE = <<~RUBY
    class FooTest < Minitest::Test
      def not_test_case; end
      def test_with_arguments(arg); end
      def test_public; end

      protected
      def test_protected; end

      private
      def test_private; end
    end
  RUBY

  def test_test_case_returns_true_for_test_case
    assert Helper.test_case?(method_node(:test_public))
  end

  def test_test_case_returns_false_for_hidden_test_methods
    refute Helper.test_case?(method_node(:test_protected))
    refute Helper.test_case?(method_node(:test_private))
  end

  def test_test_case_returns_false_for_non_test_methods
    refute Helper.test_case?(method_node(:non_test_case))
  end

  def test_test_case_returns_false_for_test_methods_with_arguments
    refute Helper.test_case?(method_node(:test_with_arguments))
  end

  # Tests for test_class? method
  def test_test_class_returns_true_for_minitest_test
    source = 'class FooTest < Minitest::Test; end'
    assert Helper.test_class?(parse_source!(source).ast)
  end

  def test_test_class_returns_true_regardless_of_class_name
    source = 'class Foo < Minitest::Test; end'
    assert Helper.test_class?(parse_source!(source).ast)
  end

  def test_test_class_returns_false_for_non_test_parent
    source = 'class FooTest < ApplicationRecord; end'
    refute Helper.test_class?(parse_source!(source).ast)
  end

  def test_test_class_returns_true_for_activesupport_testcase
    source = 'class FooTest < ActiveSupport::TestCase; end'
    assert Helper.test_class?(parse_source!(source).ast)
  end

  def test_test_class_returns_true_for_actioncontroller_testcase
    source = 'class MyController < ActionController::TestCase; end'
    assert Helper.test_class?(parse_source!(source).ast)
  end

  def test_test_class_returns_true_for_actiondispatch_integrationtest
    source = 'class MyIntegration < ActionDispatch::IntegrationTest; end'
    assert Helper.test_class?(parse_source!(source).ast)
  end

  def test_test_class_returns_false_without_parent_class
    source = 'class FooTest; end'
    refute Helper.test_class?(parse_source!(source).ast)
  end

  def test_test_class_returns_false_for_unknown_parent
    source = 'class TestHelper < ActionMailer::Base; end'
    refute Helper.test_class?(parse_source!(source).ast)
  end

  def test_test_base_classes_contains_default_classes
    expected_classes = %w[
      Minitest::Test
      ActiveSupport::TestCase
      ActionController::TestCase
      ActionDispatch::IntegrationTest
    ]

    assert_equal expected_classes, Helper.test_base_classes
  end

  private

  def method_node(method_name)
    class_node = parse_source!(SOURCE).ast
    class_node.body.each_child_node(:def).find { |def_node| def_node.method?(method_name) }
  end
end
