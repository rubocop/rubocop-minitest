# Change log

## master (unreleased)

## 0.21.0 (2022-07-31)

### New features

* [#109](https://github.com/rubocop/rubocop-minitest/issues/109): Add new `Minitest/AssertRaisesCompoundBody` cop. ([@fatkodima][])

## 0.20.1 (2022-06-13)

### Bug fixes

* [#175](https://github.com/rubocop/rubocop-minitest/pull/175): Fix raise error when using assert with block. ([@ippachi][])

## 0.20.0 (2022-05-29)

### New features

* [#169](https://github.com/rubocop/rubocop-minitest/issues/169): Add new `Minitest/SkipEnsure` cop. ([@koic][])

### Bug fixes

* [#172](https://github.com/rubocop/rubocop-minitest/issues/172): Fix a false positive for `Minitest/AssertPredicate` and `Minitest/RefutePredicate` when using numbered parameters. ([@koic][])

### Changes

* [#168](https://github.com/rubocop/rubocop-minitest/pull/168): **(Compatibility)** Drop Ruby 2.5 support. ([@koic][])

## 0.19.1 (2022-04-10)

### Bug fixes

* [#167](https://github.com/rubocop/rubocop-minitest/pull/167): Fix potential for valid Ruby code to be unparsable in `Minitest/DuplicateTestRun` cop. ([@gjtorikian][])

## 0.19.0 (2022-04-05)

### New features

* [#164](https://github.com/rubocop/rubocop-minitest/pull/164): Add new `Minitest/DuplicateTestRun` cop. ([@ignacio-chiazzo][])

## 0.18.0 (2022-03-13)

### New features

* [#161](https://github.com/rubocop/rubocop-minitest/pull/161): Add new `Minitest/AssertPredicate` and `Minitest/RefutePredicate` cops. ([@koic][])

### Changes

* [#162](https://github.com/rubocop/rubocop-minitest/pull/162): Make `Minitest/AssertNil` (`Minitest/RefuteNil`) aware of `assert_predicate(obj, :nil?)` (`refute_predicate(obj, :nil?)`). ([@koic][])

## 0.17.2 (2022-02-12)

### Bug fixes

* [#159](https://github.com/rubocop/rubocop-minitest/issues/159): Fix a false positive for `Minitest/UnreachableAssertion` when using only one assertion method in `assert_raises` block. ([@koic][])

## 0.17.1 (2022-01-30)

### Changes

* [#158](https://github.com/rubocop/rubocop-minitest/pull/158): Make `Minitest/UnreachableAssertion` aware of `assert` and `refute` prefix methods. ([@koic][])

## 0.17.0 (2021-11-23)

### New features

* [#155](https://github.com/rubocop/rubocop-minitest/issues/155): Provide `assert_offense`, `assert_correction`, and `assert_no_offenses` testing APIs for custom Minitest cop development. ([@koic][])

## 0.16.0 (2021-11-14)

### New features

* [#147](https://github.com/rubocop/rubocop-minitest/issues/147): Add `EnforcedStyle` config parameter for `Minitest/GlobalExpectations`. ([@gi][])

### Bug fixes

* [#142](https://github.com/rubocop/rubocop-minitest/issues/142): Fix `Minitest/GlobalExpectations` autocorrect when receiver is lambda. ([@gi][])
* [#150](https://github.com/rubocop/rubocop-minitest/issues/150): Fix a false positive for `Minitest/AssertEmpty` and `RefuteEmpty` cops when using `empty` method with any arguments. ([@koic][])

## 0.15.2 (2021-10-11)

### Bug fixes

* [#145](https://github.com/rubocop/rubocop-minitest/pull/145): Mark `Minitest/AssertEmptyLiteral` as safe autocorrection. ([@koic][])

## 0.15.1 (2021-09-26)

### Bug fixes

* [#143](https://github.com/rubocop/rubocop-minitest/issues/143): Fix an error for `Minitest/LiteralAsActualArgumentTest` when expected and actual arguments are literals. ([@koic][])

## 0.15.0 (2021-08-09)

### New features

* [#140](https://github.com/rubocop/rubocop-minitest/issues/140): Make `Minitest/AssertNil` and `Minitest/RefuteNil` aware of `assert(obj.nil?)` and `refute(obj.nil?)`. ([@koic][])

## 0.14.0 (2021-07-03)

### New features

* [#133](https://github.com/rubocop/rubocop-minitest/issues/133): Add new `Minitest/UnreachableAssertion` cop. ([@koic][])

## 0.13.0 (2021-06-20)

### New features

* [#136](https://github.com/rubocop/rubocop-minitest/pull/136): Support Active Support's `test` method for `Minitest/MultipleAssertions` and `Minitest/NoAssertions` cops. ([@koic][])

## 0.12.1 (2021-04-25)

### Bug fixes

* [#131](https://github.com/rubocop/rubocop-minitest/issues/131): Fix an error for `Minitest/MultipleAssertions` and fixes a false positive for `test` block. ([@koic][])

## 0.12.0 (2021-04-23)

### New features

* [#124](https://github.com/rubocop/rubocop-minitest/pull/124): Add new `Minitest/NoAssertions` cop. ([@ghiculescu][])

### Changes

* [#129](https://github.com/rubocop/rubocop-minitest/pull/129): **(Compatibility)** Drop Ruby 2.4 support. ([@koic][])

## 0.11.1 (2021-03-31)

### Changes

* [#126](https://github.com/rubocop/rubocop-minitest/issues/126): Mark `Minitest/AssertWithExpectedArgument` as unsafe. ([@koic][])

## 0.11.0 (2021-03-22)

### New features

* [#117](https://github.com/rubocop/rubocop-minitest/issues/117): Add new cop `Minitest/AssertWithExpectedArgument` to check for unintended usages of `assert` instead of `assert_equal`. ([@cstyles][])

### Bug fixes

* [#122](https://github.com/rubocop/rubocop-minitest/pull/122): Fix `Minitest/TestMethodName` for tests with multiple assertions. ([@ghiculescu][])

### Changes

* [#118](https://github.com/rubocop/rubocop-minitest/pull/118): **(BREAKING)** Fix `Minitest/AssertEmptyLiteral` by making it check for `assert_equal([], array)` instead of `assert([], array)`. ([@cstyles][])
* [#125](https://github.com/rubocop/rubocop-minitest/pull/125): Require RuboCop 0.90 or higher. ([@koic][])

## 0.10.3 (2021-01-12)

### Bug fixes

* [#115](https://github.com/rubocop/rubocop-minitest/issues/115): Fix a false positive for `Minitest/TestMethodName` for when defining test method has an argument, and test method without assertion methods. ([@koic][])

## 0.10.2 (2020-12-27)

### Bug fixes

* [#113](https://github.com/rubocop/rubocop-minitest/issues/113): Fix an error for `Minitest/AssertEqual` and some cops when using `assert` with block argument. ([@koic][])

## 0.10.1 (2020-07-25)

### Bug fixes

* [#106](https://github.com/rubocop/rubocop-minitest/issues/106): Fix an error for `Minitest/AssertOutput` when using gvar at top level. ([@koic][])

## 0.10.0 (2020-07-12)

### New features

* [#92](https://github.com/rubocop/rubocop-minitest/pull/92): Add new `Minitest/LiteralAsActualArgument` cop. ([@fatkodima][], [@tsmmark][])
* [#95](https://github.com/rubocop/rubocop-minitest/pull/95): Add new `Minitest/AssertionInLifecycleHook` cop. ([@fatkodima][])
* [#91](https://github.com/rubocop/rubocop-minitest/pull/91): Add new `Minitest/AssertInDelta` and `Minitest/RefuteInDelta` cops. ([@fatkodima][])
* [#89](https://github.com/rubocop/rubocop-minitest/pull/89): Add new `Minitest/TestMethodName` cop. ([@fatkodima][])
* [#83](https://github.com/rubocop/rubocop-minitest/pull/83): New cops `AssertPathExists` and `RefutePathExists` check for use of `assert_path_exists`/`refute_path_exists` instead of `assert(File.exist?(path))`/`refute(File.exist?(path))`. ([@fatkodima][])
* [#88](https://github.com/rubocop/rubocop-minitest/pull/88): Add new `Minitest/MultipleAssertions` cop. ([@fatkodima][])
* [#87](https://github.com/rubocop/rubocop-minitest/pull/87): Add new `Minitest/AssertSilent` cop. ([@fatkodima][])
* [#96](https://github.com/rubocop/rubocop-minitest/pull/96): Add new `Minitest/UnspecifiedException` cop. ([@fatkodima][])
* [#98](https://github.com/rubocop/rubocop-minitest/pull/98): Add new `Minitest/AssertOutput` cop. ([@fatkodima][])
* [#84](https://github.com/rubocop/rubocop-minitest/pull/84): New cops `AssertKindOf` and `RefuteKindOf` check for use of `assert_kind_of`/`refute_kind_of` instead of `assert(foo.kind_of?(Class))`/`refute(foo.kind_of?(Class))`. ([@fatkodima][])
* [#85](https://github.com/rubocop/rubocop-minitest/pull/85): Add autocorrect to `Rails/AssertEmptyLiteral` cop. ([@fatkodima][])

### Changes

* [#104](https://github.com/rubocop/rubocop-minitest/pull/104): Require RuboCop 0.87 or higher. ([@koic][])

## 0.9.0 (2020-04-13)

### Bug fixes

* [#75](https://github.com/rubocop/rubocop-minitest/issues/75): Fix a false negative for `Minitest/GlobalExpectations` when using global expectation methods with no arguments. ([@koic][])

### Changes

* [#73](https://github.com/rubocop/rubocop-minitest/issues/73): The Minitest department works on file names end with `_test.rb` by default. ([@koic][])
* [#77](https://github.com/rubocop/rubocop-minitest/pull/77): **(Compatibility)** Drop support for Ruby 2.3. ([@koic][])

## 0.8.1 (2020-04-06)

### Bug fixes

* [#72](https://github.com/rubocop/rubocop-minitest/pull/72): Fix some false negatives for `Minitest/GlobalExpectations`. ([@andrykonchin][])

## 0.8.0 (2020-03-24)

### New features

* [#66](https://github.com/rubocop/rubocop-minitest/issues/66): Support all expectations of `Minitest::Expectations` for `Minitest/GlobalExpectations` cop. ([@koic][])

### Bug fixes

* [#60](https://github.com/rubocop/rubocop-minitest/issues/60): Fix `Minitest/GlobalExpectations` autocorrection for chained methods. ([@tejasbubane][])
* [#69](https://github.com/rubocop/rubocop-minitest/pull/69): Fix a false negative for `Minitest/GlobalExpectations` cop when using a variable or a hash index for receiver. ([@koic][])
* [#71](https://github.com/rubocop/rubocop-minitest/pull/71): Fix a false negative for `Minitest/AssertEqual` when an argument is enclosed in redundant parentheses. ([@koic][])

## 0.7.0 (2020-03-09)

### New features

* [#60](https://github.com/rubocop/rubocop-minitest/issues/60): Add new cop `Minitest/GlobalExpectations` to check for deprecated global expectations. ([@tejasbubane][])

### Bug fixes

* [#58](https://github.com/rubocop/rubocop-minitest/pull/58): Fix a false negative for `Minitest/AssertMatch` and `Minitest/RefuteMatch` when an argument is enclosed in redundant parentheses. ([@koic][])
* [#59](https://github.com/rubocop/rubocop-minitest/pull/59): Fix a false negative for `Minitest/AssertRespondTo` and `Minitest/RefuteRespondTo` when an argument is enclosed in redundant parentheses. ([@koic][])
* [#61](https://github.com/rubocop/rubocop-minitest/pull/61): Fix a false negative for `Minitest/AssertInstanceOf` and `Minitest/RefuteInstanceOf` when an argument is enclosed in redundant parentheses. ([@koic][])
* [#62](https://github.com/rubocop/rubocop-minitest/pull/62): Fix a false negative for `Minitest/AssertEmpty` and `Minitest/RefuteEmpty` when an argument is enclosed in redundant parentheses. ([@koic][])

## 0.6.2 (2020-02-19)

### Bug fixes

* [#55](https://github.com/rubocop/rubocop-minitest/issues/55): Fix an error for `Minitest/AssertIncludes` when using local variable argument. ([@koic][])

## 0.6.1 (2020-02-18)

### Bug fixes

* [#52](https://github.com/rubocop/rubocop-minitest/issues/52): Make `Minitest/RefuteFalse` cop aware of `assert(!test)`. ([@koic][])
* [#52](https://github.com/rubocop/rubocop-minitest/issues/52): Fix a false negative for `Minitest/AssertIncludes` and `Minitest/RefuteIncludes` when an argument is enclosed in redundant parentheses. ([@koic][])

## 0.6.0 (2020-02-07)

### New features

* [#49](https://github.com/rubocop/rubocop-minitest/pull/49): New cops `AssertMatch` and `RefuteMatch` check for use of `assert_match`/`refute_match` instead of `assert(foo.match(bar))`/`refute(foo.match(bar))`. ([@fsateler][])

## 0.5.1 (2019-12-25)

### Bug fixes

* [#42](https://github.com/rubocop/rubocop-minitest/issues/42): Fix an incorrect autocorrect for some cops of `Minitest` department when using heredoc message. ([@koic][])

## 0.5.0 (2019-11-24)

### New features

* [#32](https://github.com/rubocop/rubocop-minitest/issues/32): Add new `Minitest/AssertEmptyLiteral` cop. ([@tejasbubane][])

## 0.4.1 (2019-11-10)

### Bug fixes

* [#39](https://github.com/rubocop/rubocop-minitest/issues/39): Fix an incorrect autocorrect for `Minitest/AssertRespondTo` and `Minitest/RefuteRespondTo` when using assertion method calling `respond_to` with receiver omitted. ([@koic][])

## 0.4.0 (2019-11-07)

### New features

* [#29](https://github.com/rubocop/rubocop-minitest/pull/29): Add new `Minitest/RefuteRespondTo` cop.  ([@herwinw][])
* [#31](https://github.com/rubocop/rubocop-minitest/pull/31): Add new `Minitest/AssertEqual` cop. ([@herwinw][])
* [#34](https://github.com/rubocop/rubocop-minitest/pull/34): Add new `Minitest/AssertInstanceOf` cop. ([@abhaynikam][])
* [#35](https://github.com/rubocop/rubocop-minitest/pull/35): Add new `Minitest/RefuteInstanceOf` cop. ([@abhaynikam][])

### Bug fixes

* [#25](https://github.com/rubocop/rubocop-minitest/issues/25): Add `Enabled: true` to `Minitest` department config to suppress `Warning: Minitest does not support Enabled parameter`. ([@koic][])

## 0.3.0 (2019-10-13)

### New features

* [#15](https://github.com/rubocop/rubocop-minitest/pull/15): Add new `Minitest/RefuteIncludes` cop. ([@abhaynikam][])
* [#18](https://github.com/rubocop/rubocop-minitest/pull/18): Add new `Minitest/RefuteFalse` cop. ([@duduribeiro][])
* [#20](https://github.com/rubocop/rubocop-minitest/pull/20): Add new `Minitest/RefuteEmpty` cop. ([@abhaynikam][])
* [#21](https://github.com/rubocop/rubocop-minitest/pull/21): Add new `Minitest/RefuteEqual` cop. ([@duduribeiro][])
* [#27](https://github.com/rubocop/rubocop-minitest/pull/27): Add new `Minitest/AssertRespondTo` cop. ([@duduribeiro][])

### Bug fixes

* [#19](https://github.com/rubocop/rubocop-minitest/pull/19): Fix a false negative for `Minitest/AssertIncludes` when using `include` method in arguments of `assert` method. ([@abhaynikam][])

## 0.2.1 (2019-09-24)

### Bug fixes

* [#13](https://github.com/rubocop/rubocop-minitest/issues/13): Fix the execution target specified in `Include` parameter. ([@koic][])

## 0.2.0 (2019-09-21)

### New features

* [#11](https://github.com/rubocop/rubocop-minitest/pull/11): Add new `Minitest/RefuteNil` cop. ([@tejasbubane][])
* [#8](https://github.com/rubocop/rubocop-minitest/pull/8): Add new `Minitest/AssertTruthy` cop. ([@abhaynikam][])
* [#9](https://github.com/rubocop/rubocop-minitest/pull/9): Add new `Minitest/AssertIncludes` cop. ([@abhaynikam][])
* [#10](https://github.com/rubocop/rubocop-minitest/pull/10): Add new `Minitest/AssertEmpty` cop. ([@abhaynikam][])

## 0.1.0 (2019-09-01)

### New features

* Create RuboCop Minitest gem. ([@koic][])
* [#6](https://github.com/rubocop/rubocop-minitest/pull/6): Add new `Minitest/AssertNil` cop. ([@duduribeiro][])

[@koic]: https://github.com/koic
[@duduribeiro]: https://github.com/duduribeiro
[@tejasbubane]: https://github.com/tejasbubane
[@abhaynikam]: https://github.com/abhaynikam
[@herwinw]: https://github.com/herwinw
[@fsateler]: https://github.com/fsateler
[@andrykonchin]: https://github.com/andrykonchin
[@fatkodima]: https://github.com/fatkodima
[@tsmmark]: https://github.com/tsmmark
[@cstyles]: https://github.com/cstyles
[@ghiculescu]: https://github.com/ghiculescu
[@gi]: https://github.com/gi
[@ignacio-chiazzo]: https://github.com/ignacio-chiazzo
[@gjtorikian]: https://github.com/gjtorikian
[@ippachi]: https://github.com/ippachi
