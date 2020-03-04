# frozen_string_literal: true

module RuboCop
  module Cop
    # Define the rule for `Minitest/AssertIncludes` and `Minitest/RefuteIncludes` cops.
    module MinitestCopRule
      def rule(assertion_method, target_method:, preferred_method: nil)
        if preferred_method.nil?
          preferred_method = "#{assertion_method}_#{target_method.to_s.delete('?')}"
        end

        class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
          include ArgumentRangeHelper

          MSG = 'Prefer using `#{preferred_method}(%<new_arguments>s)` over ' \
                '`#{assertion_method}(%<original_arguments>s)`.'

          def on_send(node)
            return unless node.method?(:#{assertion_method})
            return unless (arguments = peel_redundant_parentheses_from(node.arguments))
            return unless arguments.first.respond_to?(:method?) && arguments.first.method?(:#{target_method})

            add_offense(node, message: offense_message(arguments))
          end

          def autocorrect(node)
            lambda do |corrector|
              corrector.replace(node.loc.selector, '#{preferred_method}')

              arguments = peel_redundant_parentheses_from(node.arguments)
              receiver = correct_receiver(arguments.first.receiver)

              new_arguments = [
                receiver,
                arguments.first.arguments.map(&:source)
              ].join(', ')

              if enclosed_in_redundant_parentheses?(node)
                new_arguments = '(' + new_arguments + ')'
              end

              corrector.replace(first_argument_range(node), new_arguments)
            end
          end

          private

          def peel_redundant_parentheses_from(arguments)
            return arguments unless arguments.first.begin_type?

            peel_redundant_parentheses_from(arguments.first.children)
          end

          def offense_message(arguments)
            new_arguments = new_arguments(arguments)

            original_arguments = arguments.map(&:source).join(', ')

            format(
              MSG,
              new_arguments: new_arguments,
              original_arguments: original_arguments
            )
          end

          def new_arguments(arguments)
            receiver = correct_receiver(arguments.first.receiver)
            message_argument = arguments.last if arguments.first != arguments.last

            [
              receiver,
              arguments.first.arguments.first.source,
              message_argument&.source
            ].compact.join(', ')
          end

          def enclosed_in_redundant_parentheses?(node)
            node.arguments.first.begin_type?
          end

          def correct_receiver(receiver)
            receiver ? receiver.source : 'self'
          end
        RUBY
      end
    end
  end
end
