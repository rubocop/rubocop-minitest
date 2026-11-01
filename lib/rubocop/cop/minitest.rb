# frozen_string_literal: true

module RuboCop
  module Cop
    # Mixins are autoloaded because they're used only when the relevant cop class is loaded.
    autoload :ArgumentRangeHelper, "#{__dir__}/mixin/argument_range_helper"
    autoload :InDeltaMixin, "#{__dir__}/mixin/in_delta_mixin"
    autoload :MinitestCopRule, "#{__dir__}/mixin/minitest_cop_rule"
    autoload :MinitestExplorationHelpers, "#{__dir__}/mixin/minitest_exploration_helpers"

    # Cops for the `Minitest` department. The department's cops are registered for lazy loading and their files,
    # along with the mixins they use, are loaded on demand.
    module Minitest
      autoload :InstanceOfAssertionHandleable, "#{__dir__}/mixin/instance_of_assertion_handleable"
      autoload :NilAssertionHandleable, "#{__dir__}/mixin/nil_assertion_handleable"
      autoload :PredicateAssertionHandleable, "#{__dir__}/mixin/predicate_assertion_handleable"

      extend LazyLoader

      register_cop :AssertEmpty, "#{__dir__}/minitest/assert_empty"
      register_cop :AssertEmptyLiteral, "#{__dir__}/minitest/assert_empty_literal"
      register_cop :AssertEqual, "#{__dir__}/minitest/assert_equal"
      register_cop :AssertInDelta, "#{__dir__}/minitest/assert_in_delta"
      register_cop :AssertOperator, "#{__dir__}/minitest/assert_operator"
      register_cop :AssertPredicate, "#{__dir__}/minitest/assert_predicate"
      register_cop :AssertRaisesCompoundBody, "#{__dir__}/minitest/assert_raises_compound_body"
      register_cop :AssertRaisesWithRegexpArgument, "#{__dir__}/minitest/assert_raises_with_regexp_argument"
      register_cop :AssertWithExpectedArgument, "#{__dir__}/minitest/assert_with_expected_argument"
      register_cop :AssertionInLifecycleHook, "#{__dir__}/minitest/assertion_in_lifecycle_hook"
      register_cop :AssertKindOf, "#{__dir__}/minitest/assert_kind_of"
      register_cop :AssertNil, "#{__dir__}/minitest/assert_nil"
      register_cop :AssertIncludes, "#{__dir__}/minitest/assert_includes"
      register_cop :AssertInstanceOf, "#{__dir__}/minitest/assert_instance_of"
      register_cop :AssertMatch, "#{__dir__}/minitest/assert_match"
      register_cop :AssertOutput, "#{__dir__}/minitest/assert_output"
      register_cop :AssertPathExists, "#{__dir__}/minitest/assert_path_exists"
      register_cop :AssertRespondTo, "#{__dir__}/minitest/assert_respond_to"
      register_cop :AssertSame, "#{__dir__}/minitest/assert_same"
      register_cop :AssertSilent, "#{__dir__}/minitest/assert_silent"
      register_cop :AssertTruthy, "#{__dir__}/minitest/assert_truthy"
      register_cop :DuplicateTestRun, "#{__dir__}/minitest/duplicate_test_run"
      register_cop :EmptyLineBeforeAssertionMethods, "#{__dir__}/minitest/empty_line_before_assertion_methods"
      register_cop :Focus, "#{__dir__}/minitest/focus"
      register_cop :NonExecutableTestMethod, "#{__dir__}/minitest/non_executable_test_method"
      register_cop :RedundantMessageArgument, "#{__dir__}/minitest/redundant_message_argument"
      register_cop :ReturnInTestMethod, "#{__dir__}/minitest/return_in_test_method"
      register_cop :TestClassName, "#{__dir__}/minitest/test_class_name"
      register_cop :TestFileName, "#{__dir__}/minitest/test_file_name"
      register_cop :GlobalExpectations, "#{__dir__}/minitest/global_expectations"
      register_cop :LifecycleHooksOrder, "#{__dir__}/minitest/lifecycle_hooks_order"
      register_cop :LiteralAsActualArgument, "#{__dir__}/minitest/literal_as_actual_argument"
      register_cop :MultipleAssertions, "#{__dir__}/minitest/multiple_assertions"
      register_cop :NoAssertions, "#{__dir__}/minitest/no_assertions"
      register_cop :NoTestCases, "#{__dir__}/minitest/no_test_cases"
      register_cop :NonPublicTestMethod, "#{__dir__}/minitest/non_public_test_method"
      register_cop :RefuteEmpty, "#{__dir__}/minitest/refute_empty"
      register_cop :RefuteFalse, "#{__dir__}/minitest/refute_false"
      register_cop :RefuteEqual, "#{__dir__}/minitest/refute_equal"
      register_cop :RefuteInDelta, "#{__dir__}/minitest/refute_in_delta"
      register_cop :RefuteIncludes, "#{__dir__}/minitest/refute_includes"
      register_cop :RefuteInstanceOf, "#{__dir__}/minitest/refute_instance_of"
      register_cop :RefuteKindOf, "#{__dir__}/minitest/refute_kind_of"
      register_cop :RefuteMatch, "#{__dir__}/minitest/refute_match"
      register_cop :RefuteNil, "#{__dir__}/minitest/refute_nil"
      register_cop :RefuteOperator, "#{__dir__}/minitest/refute_operator"
      register_cop :RefutePathExists, "#{__dir__}/minitest/refute_path_exists"
      register_cop :RefutePredicate, "#{__dir__}/minitest/refute_predicate"
      register_cop :RefuteRespondTo, "#{__dir__}/minitest/refute_respond_to"
      register_cop :RefuteSame, "#{__dir__}/minitest/refute_same"
      register_cop :SkipEnsure, "#{__dir__}/minitest/skip_ensure"
      register_cop :SkipWithoutReason, "#{__dir__}/minitest/skip_without_reason"
      register_cop :TestMethodName, "#{__dir__}/minitest/test_method_name"
      register_cop :UnreachableAssertion, "#{__dir__}/minitest/unreachable_assertion"
      register_cop :UnspecifiedException, "#{__dir__}/minitest/unspecified_exception"
      register_cop :UselessAssertion, "#{__dir__}/minitest/useless_assertion"
    end
  end
end
