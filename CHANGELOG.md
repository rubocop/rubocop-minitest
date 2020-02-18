# Change log

## master (unreleased)

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
