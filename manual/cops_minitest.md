# Minitest

## Minitest/AssertNil

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.1 | -

Check if your test uses `assert_nil` instead of `assert_equal(nil, something)`.

### Examples

```ruby
# bad
assert_equal(nil, actual)
assert_equal(nil, actual, 'the message')

# good
assert_nil(actual)
assert_nil(actual, 'the message')
```

### References

* [https://github.com/rubocop-hq/minitest-style-guide#assert-nil](https://github.com/rubocop-hq/minitest-style-guide#assert-nil)

## Minitest/AssertTruthy

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.2 | -

Check if your test uses `assert(actual)`
instead of `assert_equal(true, actual)`.

### Examples

```ruby
# bad
assert_equal(true, actual)
assert_equal(true, actual, 'the message')

# good
assert(actual)
assert(actual, 'the message')
```

### References

* [https://github.com/rubocop-hq/minitest-style-guide#assert-truthy](https://github.com/rubocop-hq/minitest-style-guide#assert-truthy)

## Minitest/RefuteNil

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.2 | -

Check if your test uses `refute_nil` instead of `refute_equal(nil, something)`.

### Examples

```ruby
# bad
refute_equal(nil, actual)
refute_equal(nil, actual, 'the message')

# good
refute_nil(actual)
refute_nil(actual, 'the message')
```

### References

* [https://github.com/rubocop-hq/minitest-style-guide#refute-nil](https://github.com/rubocop-hq/minitest-style-guide#refute-nil)
