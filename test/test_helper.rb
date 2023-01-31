# frozen_string_literal: true

require 'rubocop-minitest'

# Require supporting files exposed for testing.
require 'rubocop/minitest/support'
require 'minitest/proveit'

Minitest::Test.class_eval do
  prove_it!
end
