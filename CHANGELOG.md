# Change log

## master (unreleased)

## 0.9.0 (2020-04-13)

### Bug fixes

* [#75](https://github.com/rubocop-hq/rubocop-minitest/issues/75): Fix a false negative for `Minitest/GlobalExpectations` when using global expectation methods with no arguments. ([@koic][])

### Changes

* [#73](https://github.com/rubocop-hq/rubocop-minitest/issues/73): The Minitest department works on file names end with `_test.rb` by default. ([@koic][])
* [#77](https://github.com/rubocop-hq/rubocop-minitest/pull/77): **(BREAKING)** Drop support for Ruby 2.3. ([@koic][])

## 0.8.1 (2020-04-06)

### Bug fixes

* [#72](https://github.com/rubocop-hq/rubocop-minitest/pull/72): Fix some false negatives for `Minitest/GlobalExpectations`. ([@andrykonchin][])

## 0.8.0 (2020-03-24)

### New features

* [#66](https://github.com/rubocop-hq/rubocop-minitest/issues/66): Support all expectations of `Minitest::Expectations` for `Minitest/GlobalExpectations` cop. ([@koic][])

### Bug fixes

* [#60](https://github.com/rubocop-hq/rubocop-minitest/issues/60): Fix `Minitest/GlobalExpectations` autocorrection for chained methods. ([@tejasbubane][])
* [#69](https://github.com/rubocop-hq/rubocop-minitest/pull/69): Fix a false negative for `Minitest/GlobalExpectations` cop when using a variable or a hash index for receiver. ([@koic][])
* [#71](https://github.com/rubocop-hq/rubocop-minitest/pull/71): Fix a false negative for `Minitest/AssertEqual` when an argument is enclosed in redundant parentheses. ([@koic][])

## 0.7.0 (2020-03-09)

### New features

* [#60](https://github.com/rubocop-hq/rubocop-minitest/issues/60): Add new cop `Minitest/GlobalExpectations` to check for deprecated global expectations. ([@tejasbubane][])

### Bug fixes

* [#58](https://github.com/rubocop-hq/rubocop-minitest/pull/58): Fix a false negative for `Minitest/AssertMatch` and `Minitest/RefuteMatch` when an argument is enclosed in redundant parentheses. ([@koic][])
* [#59](https://github.com/rubocop-hq/rubocop-minitest/pull/59): Fix a false negative for `Minitest/AssertRespondTo` and `Minitest/RefuteRespondTo` when an argument is enclosed in redundant parentheses. ([@koic][])
* [#61](https://github.com/rubocop-hq/rubocop-minitest/pull/61): Fix a false negative for `Minitest/AssertInstanceOf` and `Minitest/RefuteInstanceOf` when an argument is enclosed in redundant parentheses. ([@koic][])
* [#62](https://github.com/rubocop-hq/rubocop-minitest/pull/62): Fix a false negative for `Minitest/AssertEmpty` and `Minitest/RefuteEmpty` when an argument is enclosed in redundant parentheses. ([@koic][])

## 0.6.2 (2020-02-19)

### Bug fixes

* [#55](https://github.com/rubocop-hq/rubocop-minitest/issues/55): Fix an error for `Minitest/AssertIncludes` when using local variable argument. ([@koic][])

## 0.6.1 (2020-02-18)

### Bug fixes

* [#52](https://github.com/rubocop-hq/rubocop-minitest/issues/52): Make `Minitest/RefuteFalse` cop aware of `assert(!test)`. ([@koic][])
* [#52](https://github.com/rubocop-hq/rubocop-minitest/issues/52): Fix a false negative for `Minitest/AssertIncludes` and `Minitest/RefuteIncludes` when an argument is enclosed in redundant parentheses. ([@koic][])

## 0.6.0 (2020-02-07)

### New features

* [#49](https://github.com/rubocop-hq/rubocop-minitest/pull/49): New cops `AssertMatch` and `RefuteMatch` check for use of `assert_match`/`refute_match` instead of `assert(foo.match(bar))`/`refute(foo.match(bar))`. ([@fsateler][])

## 0.5.1 (2019-12-25)

### Bug fixes

* [#42](https://github.com/rubocop-hq/rubocop-minitest/issues/42): Fix an incorrect autocorrect for some cops of `Minitest` department when using heredoc message. ([@koic][])

## 0.5.0 (2019-11-24)

### New features

* [#32](https://github.com/rubocop-hq/rubocop-minitest/issues/32): Add new `Minitest/AssertEmptyLiteral` cop. ([@tejasbubane][])

## 0.4.1 (2019-11-10)

### Bug fixes

* [#39](https://github.com/rubocop-hq/rubocop-minitest/issues/39): Fix an incorrect autocorrect for `Minitest/AssertRespondTo` and `Minitest/RefuteRespondTo` when using assertion method calling `respond_to` with receiver omitted. ([@koic][])

## 0.4.0 (2019-11-07)

### New features

* [#29](https://github.com/rubocop-hq/rubocop-minitest/pull/29): Add new `Minitest/RefuteRespondTo` cop.  ([@herwinw][])
* [#31](https://github.com/rubocop-hq/rubocop-minitest/pull/31): Add new `Minitest/AssertEqual` cop. ([@herwinw][])
* [#34](https://github.com/rubocop-hq/rubocop-minitest/pull/34): Add new `Minitest/AssertInstanceOf` cop. ([@abhaynikam][])
* [#35](https://github.com/rubocop-hq/rubocop-minitest/pull/35): Add new `Minitest/RefuteInstanceOf` cop. ([@abhaynikam][])

### Bug fixes

* [#25](https://github.com/rubocop-hq/rubocop-minitest/issues/25): Add `Enabled: true` to `Minitest` department config to suppress `Warning: Minitest does not support Enabled parameter`. ([@koic][])

## 0.3.0 (2019-10-13)

### New features

* [#15](https://github.com/rubocop-hq/rubocop-minitest/pull/15): Add new `Minitest/RefuteIncludes` cop. ([@abhaynikam][])
* [#18](https://github.com/rubocop-hq/rubocop-minitest/pull/18): Add new `Minitest/RefuteFalse` cop. ([@duduribeiro][])
* [#20](https://github.com/rubocop-hq/rubocop-minitest/pull/20): Add new `Minitest/RefuteEmpty` cop. ([@abhaynikam][])
* [#21](https://github.com/rubocop-hq/rubocop-minitest/pull/21): Add new `Minitest/RefuteEqual` cop. ([@duduribeiro][])
* [#27](https://github.com/rubocop-hq/rubocop-minitest/pull/27): Add new `Minitest/AssertRespondTo` cop. ([@duduribeiro][])

### Bug fixes

* [#19](https://github.com/rubocop-hq/rubocop-minitest/pull/19): Fix a false negative for `Minitest/AssertIncludes` when using `include` method in arguments of `assert` method. ([@abhaynikam][])

## 0.2.1 (2019-09-24)

### Bug fixes

* [#13](https://github.com/rubocop-hq/rubocop-minitest/issues/13): Fix the execution target specified in `Include` parameter. ([@koic][])

## 0.2.0 (2019-09-21)

### New features

* [#11](https://github.com/rubocop-hq/rubocop-minitest/pull/11): Add new `Minitest/RefuteNil` cop. ([@tejasbubane][])
* [#8](https://github.com/rubocop-hq/rubocop-minitest/pull/8): Add new `Minitest/AssertTruthy` cop. ([@abhaynikam][])
* [#9](https://github.com/rubocop-hq/rubocop-minitest/pull/9): Add new `Minitest/AssertIncludes` cop. ([@abhaynikam][])
* [#10](https://github.com/rubocop-hq/rubocop-minitest/pull/10): Add new `Minitest/AssertEmpty` cop. ([@abhaynikam][])

## 0.1.0 (2019-09-01)

### New features

* Create RuboCop Minitest gem. ([@koic][])
* [#6](https://github.com/rubocop-hq/rubocop-minitest/pull/6): Add new `Minitest/AssertNil` cop. ([@duduribeiro][])

[@koic]: https://github.com/koic
[@duduribeiro]: https://github.com/duduribeiro
[@tejasbubane]: https://github.com/tejasbubane
[@abhaynikam]: https://github.com/abhaynikam
[@herwinw]: https://github.com/herwinw
[@fsateler]: https://github.com/fsateler
[@andrykonchin]: https://github.com/andrykonchin
