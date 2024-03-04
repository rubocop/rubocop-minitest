# RuboCop Minitest

[![Gem Version](https://badge.fury.io/rb/rubocop-minitest.svg)](https://badge.fury.io/rb/rubocop-minitest)
[![CircleCI](https://circleci.com/gh/rubocop/rubocop-minitest.svg?style=svg)](https://circleci.com/gh/rubocop/rubocop-minitest)

A [RuboCop](https://github.com/rubocop/rubocop) extension focused on enforcing [Minitest](https://github.com/minitest/minitest) best practices and coding conventions.
The library is based on the guidelines outlined in the community [Minitest Style Guide](https://minitest.rubystyle.guide).

## Installation

Just install the `rubocop-minitest` gem

```sh
$ gem install rubocop-minitest
```

or if you use bundler put this in your `Gemfile`

```ruby
gem 'rubocop-minitest', require: false
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

```sh
$ rubocop --require rubocop-minitest
```

### Rake task

```ruby
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-minitest'
end
```

## The Cops

All cops are located under
[`lib/rubocop/cop/minitest`](lib/rubocop/cop/minitest), and contain
examples/documentation. The documentation is published [here](https://docs.rubocop.org/rubocop-minitest/).

In your `.rubocop.yml`, you may treat the Minitest cops just like any other
cop. For example:

```yaml
Minitest/AssertNil:
  Exclude:
    - test/my_file_to_ignore_test.rb
```

## Documentation

You can read a lot more about RuboCop Minitest in its [official docs](https://docs.rubocop.org/rubocop-minitest/).

## Readme Badge

If you use RuboCop Minitest in your project, you can include one of these badges in your readme to let people know that your code is written following the community Minitest Style Guide.

[![Minitest Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop-minitest)

[![Minitest Style Guide](https://img.shields.io/badge/code_style-community-brightgreen.svg)](https://minitest.rubystyle.guide)

Here are the Markdown snippets for the two badges:

``` markdown
[![Minitest Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop-minitest)

[![Minitest Style Guide](https://img.shields.io/badge/code_style-community-brightgreen.svg)](https://minitest.rubystyle.guide)
```

## Using this Gem for testing custom cops

You can use this gem to test your own cops, by using the `RuboCop::Minitest::Test` test class, you'll get `assert_offense`, `assert_correction`, and `assert_no_offense` helpers

```ruby

require "rubocop/minitest/support"
require "custom_cops/my_cop"

module CustomCops
  class MyCopTest < RuboCop::Minitest::Test
    def test_registers_offense
      assert_offense(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            assert_equal(nil, somestuff)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
          end
        end
      RUBY
    end

    def test_assert_offense_and_correction
      assert_offense(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            assert_equal(nil, somestuff)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
          end
        end
      RUBY

      assert_correction(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            assert_nil(somestuff)
          end
        end
      RUBY
    end

    def test_assert_offense_and_no_corrections
      assert_offense(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            assert_equal(nil, somestuff)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
          end
        end
      RUBY

      assert_no_corrections
    end

    def test_assert_no_offense
      assert_no_offenses(<<~RUBY)
        class FooTest < Minitest::Test
          def test_do_something
            assert_nil(somestuff)
          end
        end
      RUBY
    end

    # You can set the `@cop` attribute to override the auto-detected cop and provide configuration options
    def test_override_cop_configuration
      cop_config = RuboCop::Config.new('Minitest/MultipleAssertions' => { 'Max' => 1 })
      @cop = RuboCop::Cop::Minitest::MultipleAssertions.new(cop_config)

      assert_offense(<<~RUBY)
        class FooTest < Minitest::Test
          def test_asserts_twice
          ^^^^^^^^^^^^^^^^^^^^^^ Test case has too many assertions [2/1].
            assert_equal(foo, bar)
            assert_empty(array)
          end
        end
      RUBY
    end
  end
end
```

## Contributing

Checkout the [contribution guidelines](CONTRIBUTING.md).

## License

`rubocop-minitest` is MIT licensed. [See the accompanying file](LICENSE.txt) for
the full text.
