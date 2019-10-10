# Minitest

## Minitest/AssertEmpty

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.2 | -

This cop enforces the test to use `assert_empty`
instead of using `assert(object.empty?)`.

### Examples

```ruby
# bad
assert(object.empty?)
assert(object.empty?, 'the message')

# good
assert_empty(object)
assert_empty(object, 'the message')
```

### References

* [https://github.com/rubocop-hq/minitest-style-guide#assert-empty](https://github.com/rubocop-hq/minitest-style-guide#assert-empty)

## Minitest/AssertIncludes

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.2 | -

This cop enforces the test to use `assert_includes`
instead of using `assert(collection.include?(object))`.

### Examples

```ruby
# bad
assert(collection.include?(object))
assert(collection.include?(object), 'the message')

# good
assert_includes(collection, object)
assert_includes(collection, object, 'the message')
```

### References

* [https://github.com/rubocop-hq/minitest-style-guide#assert-includes](https://github.com/rubocop-hq/minitest-style-guide#assert-includes)

## Minitest/AssertNil

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.1 | -

This cop enforces the test to use `assert_nil`
instead of using `assert_equal(nil, something)`.

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

This cop enforces the test to use `assert(actual)`
instead of using `assert_equal(true, actual)`.

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

## Minitest/RefuteEmpty

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.3 | -

This cop enforces to use `refute_empty` instead of
using `refute(object.empty?)`.

### Examples

```ruby
# bad
refute(object.empty?)
refute(object.empty?, 'the message')

# good
refute_empty(object)
refute_empty(object, 'the message')
```

### References

* [https://github.com/rubocop-hq/minitest-style-guide#refute-empty](https://github.com/rubocop-hq/minitest-style-guide#refute-empty)

## Minitest/RefuteIncludes

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.3 | -

This cop enforces the test to use `refute_includes`
instead of using `refute(collection.include?(object))`.

### Examples

```ruby
# bad
refute(collection.include?(object))
refute(collection.include?(object), 'the message')

# good
refute_includes(collection, object)
refute_includes(collection, object, 'the message')
```

### References

* [https://github.com/rubocop-hq/minitest-style-guide#refute-includes](https://github.com/rubocop-hq/minitest-style-guide#refute-includes)

## Minitest/RefuteNil

Enabled by default | Safe | Supports autocorrection | VersionAdded | VersionChanged
--- | --- | --- | --- | ---
Enabled | Yes | Yes  | 0.2 | -

This cop enforces the test to use `refute_nil`
instead of using `refute_equal(nil, something)`.

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
