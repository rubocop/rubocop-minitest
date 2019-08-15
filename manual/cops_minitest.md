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
