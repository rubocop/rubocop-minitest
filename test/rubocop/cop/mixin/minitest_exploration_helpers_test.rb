# frozen_string_literal: true

require_relative '../../../test_helper'

class MinitestExplorationHelpersTest < Minitest::Test
  module Helper
    extend RuboCop::Cop::MinitestExplorationHelpers
    class << self
      public :test_case?
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

  def test_MINITEST_ASSERTIONS # rubocop:disable Naming/MethodName
    assert_equal 38, RuboCop::Cop::MinitestExplorationHelpers::MINITEST_ASSERTIONS.size
  end

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

  private

  def method_node(method_name)
    class_node = parse_source!(SOURCE).ast
    class_node.body.each_child_node(:def).find { |def_node| def_node.method?(method_name) }
  end
end
