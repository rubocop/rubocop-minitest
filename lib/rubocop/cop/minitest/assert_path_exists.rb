# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # This cop enforces the test to use `assert_path_exists`
      # instead of using `assert(File.exist?(path))`.
      #
      # @example
      #   # bad
      #   assert(File.exist?(path))
      #   assert(File.exist?(path), 'message')
      #
      #   # good
      #   assert_path_exists(path)
      #   assert_path_exists(path, 'message')
      #
      class AssertPathExists < Cop
        MSG = 'Prefer using `%<good_method>s` over `%<bad_method>s`.'

        def_node_matcher :assert_file_exists, <<~PATTERN
          (send nil? :assert
            (send
              (const _ :File) ${:exist? :exists?} $_)
              $...)
        PATTERN

        def on_send(node)
          assert_file_exists(node) do |method_name, path, message|
            message = message.first

            add_offense(node,
                        message: format(MSG, good_method: build_good_method(path, message),
                                             bad_method: build_bad_method(method_name, path, message)))
          end
        end

        def autocorrect(node)
          assert_file_exists(node) do |_method_name, path, message|
            message = message.first

            lambda do |corrector|
              replacement = build_good_method(path, message)
              corrector.replace(node, replacement)
            end
          end
        end

        private

        def build_good_method(path, message)
          args = [path.source, message&.source].compact.join(', ')
          "assert_path_exists(#{args})"
        end

        def build_bad_method(method_name, path, message)
          path_arg = "File.#{method_name}(#{path.source})"
          if message
            "assert(#{path_arg}, #{message.source})"
          else
            "assert(#{path_arg})"
          end
        end
      end
    end
  end
end
