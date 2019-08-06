require "test_helper"

class MiniTestSpec < Minitest::Test
  def test_rubocop_minitest_gem_has_a_version_number
    refute_nil Rubocop::Minitest::VERSION
  end

  def test_rubocop_minitest_does_something_useful
    assert true
  end
end
