# frozen_string_literal: true

module RuboCop
  module Cop
    module Minitest
      # Checks that test class names match their paths relative to the nearest
      # `test` directory. Namespaces prevent unrelated test files from reopening
      # the same class and overwriting tests or lifecycle hooks.
      #
      # Only classes with a superclass and a name ending in `Test` are checked,
      # in files named `*_test.rb` or `test_*.rb` under a `test` directory.
      # Acronyms are accepted, for example `HTTPTest` in `http_test.rb`.
      #
      # `IgnoredDirectories` lists test type directories to omit when they appear
      # directly under `test`. Other directories, including nested type directory
      # names, must be represented in the class namespace.
      #
      # This cop does not detect duplicate classes across files. Ignoring test
      # type directories can still allow collisions between those directories.
      # Use `IgnoredDirectories: []` to include every directory in the namespace.
      #
      # @example IgnoredDirectories (default)
      #   # bad - test/models/admin/employee_test.rb
      #   class EmployeeTest < ActiveSupport::TestCase
      #   end
      #
      #   # good - test/models/admin/employee_test.rb
      #   class Admin::EmployeeTest < ActiveSupport::TestCase
      #   end
      #
      #   # good - test/models/employee_test.rb
      #   class EmployeeTest < ActiveSupport::TestCase
      #   end
      #
      # @example IgnoredDirectories: []
      #   # good - test/models/employee_test.rb
      #   class Models::EmployeeTest < ActiveSupport::TestCase
      #   end
      #
      class TestClassName < Base
        include MinitestExplorationHelpers

        MSG = 'Test class name should be `%<class_name>s` to match its file path.'

        def on_class(node)
          return unless test_class?(node)
          return unless (path = expected_path) && (name = qualified_name(node))
          return if name.split('::').map { |part| snake_case(part) } == path

          add_offense(node.identifier, message: format(MSG, class_name: expected_class_name(path)))
        end

        private

        def expected_path
          parts = processed_source.file_path.split(File::SEPARATOR)
          return unless (root = parts.rindex('test'))

          parts = parts.drop(root + 1)
          return unless (basename = test_file_basename(parts.last))

          parts.shift if cop_config['IgnoredDirectories'].include?(parts.first)
          parts[-1] = basename
          parts
        end

        def test_file_basename(filename)
          return unless filename&.match?(/\A(?:test_.*|.*_test)\.rb\z/)

          basename = filename.delete_suffix('.rb')
          basename.end_with?('_test') ? basename : "#{basename.delete_prefix('test_')}_test"
        end

        def expected_class_name(path)
          path.map { |part| part.split('_').map(&:capitalize).join }.join('::')
        end

        def qualified_name(node)
          names = []
          ([node] + node.each_ancestor(:class, :module).to_a).each do |scope|
            identifier = scope.identifier
            return nil if identifier.each_path.any? { |part| !part.type?(:const, :cbase) }

            names.unshift(identifier.const_name)
            break if identifier.absolute?
          end
          names.join('::')
        end

        def snake_case(name)
          name.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
        end
      end
    end
  end
end
