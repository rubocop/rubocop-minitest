# frozen_string_literal: true

require_relative '../../../test_helper'

class FocusTest < Minitest::Test
  def test_registers_offense_when_using_direct_focus
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        focus test 'foo' do
        ^^^^^ Remove `focus` from tests.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        test 'foo' do
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_indirect_focus
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        focus
        ^^^^^ Remove `focus` from tests.
        test 'foo' do
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        test 'foo' do
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_no_focus
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        test 'foo' do
        end
      end
    RUBY
  end
end
