# frozen_string_literal: true

require_relative '../../../test_helper'

class AssertOffenseTest
  class CopNotDefinedTest < Minitest::Test
    def test_correct_failure_is_raised_when_cop_is_not_defined
      error = assert_raises RuntimeError do
        assert_offense(<<~RUBY)
          class FooTest < Minitest::Test
            def test_do_something
              assert_equal(nil, somestuff)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `assert_nil(somestuff)`.
            end
          end
        RUBY
      end

      assert_includes error.message, 'Cop not defined'
    end
  end
end
