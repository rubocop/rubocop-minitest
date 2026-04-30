# frozen_string_literal: true

require 'regexp_parser'

module RuboCop
  module Cop
    module Minitest
      # Enforces the test to use `assert_includes`
      # instead of using `assert(collection.include?(object))`.
      #
      # Additionally, enforces the test to use `assert_includes` instead of `assert_match`
      # when the matcher is a simple string literal without regex-specific features
      # (like anchors, character classes, quantifiers, etc.).
      #
      # @example
      #   # bad
      #   assert(collection.include?(object))
      #   assert(collection.include?(object), 'message')
      #
      #   # good
      #   assert_includes(collection, object)
      #   assert_includes(collection, object, 'message')
      #
      # @example
      #   # bad
      #   assert_match('foo', 'foobar')
      #   assert_match(/foo/, 'foobar')
      #
      #   # good
      #   assert_includes('foobar', 'foo')
      #   assert_match(/^foo/, 'foobar') # has anchor
      #   assert_match(/foo\d+/, 'foobar') # has regex features
      #
      class AssertIncludes < Base
        extend MinitestCopRule

        MSG_MATCH = 'Prefer using `assert_includes(%<preferred>s)`.'

        define_rule :assert, target_method: %i[include? member?], preferred_method: :assert_includes

        remove_const :RESTRICT_ON_SEND
        RESTRICT_ON_SEND = %i[assert assert_match].freeze

        def_node_matcher :assert_match_method, <<~PATTERN
          (send nil? :assert_match $_ $_ $...)
        PATTERN

        remove_method :on_send
        def on_send(node)
          handle_assert(node)
          handle_assert_match(node)
        end

        private

        # Handle assert(collection.include?(object))
        def handle_assert(node)
          return unless node.method?(:assert)
          return unless node.first_argument&.call_type?
          return if node.first_argument.arguments.empty?
          return unless %i[include? member?].include?(node.first_argument.method_name)

          add_offense(node, message: offense_message(node.arguments)) do |corrector|
            autocorrect(corrector, node, node.arguments)
          end
        end

        # Handle assert_match(/foo/, 'foobar')
        def handle_assert_match(node) # rubocop:disable Metrics/AbcSize
          assert_match_method(node) do |matcher, actual, rest_args|
            next unless simple_regexp?(matcher)

            preferred_args = "#{actual.source}, #{regexp_to_string(matcher)}"
            preferred = (message_arg = rest_args.first) ? "#{preferred_args}, #{message_arg.source}" : preferred_args
            message = format(MSG_MATCH, preferred: preferred)

            add_offense(node, message: message) do |corrector|
              corrector.replace(node.loc.selector, 'assert_includes')
              corrector.replace(node.first_argument.source_range.join(node.arguments[1].source_range), preferred_args)
            end
          end
        end

        def simple_regexp?(node)
          return false if node.interpolation?
          return false if node.regopt.children.any?

          parsed = Regexp::Parser.parse(node.content)
          parsed.expressions.all? { |expr| simple_expression?(expr) }
        rescue Regexp::Parser::Error, RegexpError
          false
        end

        def simple_expression?(expr)
          return false if expr.quantified?
          return true if expr.is_a?(Regexp::Expression::Literal)
          return true if expr.is_a?(Regexp::Expression::EscapeSequence::Literal)

          false
        end

        # Reconstruct the literal string that the regex matches
        def regexp_to_string(node)
          # EscapeSequence::Literal has .char which returns the actual character
          # Regular Literal uses .text
          parsed = Regexp::Parser.parse(node.content)
          string_content = parsed.expressions.map do |expr|
            expr.respond_to?(:char) ? expr.char : expr.text
          end.join

          to_string_literal(string_content)
        end

        def to_string_literal(string)
          if string.include?("'")
            %("#{string.gsub('"', '\"')}")
          else
            "'#{string}'"
          end
        end
      end
    end
  end
end
