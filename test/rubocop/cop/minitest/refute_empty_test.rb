# frozen_string_literal: true

require 'test_helper'

class RefuteEmptyTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::RefuteEmpty.new
  end

  def test_registers_offense_when_using_refute_with_empty
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff.empty?)
          ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_empty(somestuff)` over `refute(somestuff.empty?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_empty(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_empty_and_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff.empty?, 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_empty(somestuff, 'the message')` over `refute(somestuff.empty?, 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_empty(somestuff, 'the message')
        end
      end
    RUBY
  end

  def refute_empty_method
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_empty(somestuff)
        end
      end
    RUBY
  end
end
