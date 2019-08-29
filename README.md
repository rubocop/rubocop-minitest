# RuboCop Minitest

This is a repository reserved for minitest-specific analysis for your projects, as an extension to [RuboCop](https://github.com/rubocop-hq/rubocop).

## Installation

Just install the `rubocop-minitest` gem

```bash
gem install rubocop-minitest
```

or if you use bundler put this in your `Gemfile`

```
gem 'rubocop-minitest'
```

## Usage

You need to tell RuboCop to load the Minitest extension. There are three
ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```yaml
require: rubocop-minitest
```

Alternatively, use the following array notation when specifying multiple extensions.

```yaml
require:
  - rubocop-other-extension
  - rubocop-minitest
```

Now you can run `rubocop` and it will automatically load the RuboCop Minitest
cops together with the standard cops.

### Command line

```bash
rubocop --require rubocop-minitest
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-minitest'
end
```

## The Cops

All cops are located under
[`lib/rubocop/cop/minitest`](lib/rubocop/cop/minitest), and contain
examples/documentation.

In your `.rubocop.yml`, you may treat the Minitest cops just like any other
cop. For example:

```yaml
Minitest/AssertNil:
  Exclude:
    - test/my_file_to_ignore_test.rb
```
