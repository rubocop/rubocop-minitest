# frozen_string_literal: true

require_relative '../lib/rubocop-minitest'

# Require supporting files exposed for testing.
require_relative '../lib/rubocop/minitest/support'
require 'minitest/proveit'
require 'minitest/pride'
require 'minitest/autorun'

Minitest::Test.class_eval do
  prove_it!
end
