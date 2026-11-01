# frozen_string_literal: true

require_relative '../../../test_helper'

class TestClassNameTest < RuboCop::TestCase
  def test_registers_offense_for_missing_namespace
    assert_offense(<<~RUBY, 'test/admin/employee_test.rb')
      class EmployeeTest < ActiveSupport::TestCase
            ^^^^^^^^^^^^ Test class name should be `Admin::EmployeeTest` to match its file path.
      end
    RUBY

    assert_no_corrections
  end

  def test_registers_offense_for_wrong_basename
    assert_offense(<<~RUBY, 'test/models/employee_test.rb')
      class UserTest < Minitest::Test
            ^^^^^^^^ Test class name should be `EmployeeTest` to match its file path.
      end
    RUBY
  end

  def test_accepts_top_level_class
    assert_no_offenses(<<~RUBY, 'test/employee_test.rb')
      class EmployeeTest < Minitest::Test; end
    RUBY
  end

  def test_accepts_compact_namespace
    assert_no_offenses(<<~RUBY, 'test/admin/employee_test.rb')
      class Admin::EmployeeTest < Minitest::Test; end
    RUBY
  end

  def test_accepts_nested_modules
    assert_no_offenses(<<~RUBY, 'test/admin/payroll/employee_test.rb')
      module Admin
        module Payroll
          class EmployeeTest < Minitest::Test; end
        end
      end
    RUBY
  end

  def test_checks_namespace_of_enclosing_module
    assert_offense(<<~RUBY, 'test/admin/employee_test.rb')
      module Payroll
        class EmployeeTest < Minitest::Test
              ^^^^^^^^^^^^ Test class name should be `Admin::EmployeeTest` to match its file path.
        end
      end
    RUBY
  end

  def test_accepts_mixed_namespace_styles
    assert_no_offenses(<<~RUBY, 'test/admin/payroll/employee_test.rb')
      module Admin
        class Payroll::EmployeeTest < Minitest::Test; end
      end
    RUBY
  end

  def test_accepts_absolute_class_name
    assert_no_offenses(<<~RUBY, 'test/admin/employee_test.rb')
      module Unrelated
        class ::Admin::EmployeeTest < Minitest::Test; end
      end
    RUBY
  end

  def test_accepts_absolute_enclosing_module
    assert_no_offenses(<<~RUBY, 'test/admin/employee_test.rb')
      module Unrelated
        module ::Admin
          class EmployeeTest < Minitest::Test; end
        end
      end
    RUBY
  end

  def test_accepts_acronyms
    assert_no_offenses(<<~RUBY, 'test/api/http_client_test.rb')
      class API::HTTPClientTest < Minitest::Test; end
    RUBY
  end

  def test_accepts_camel_case_names_with_digits
    assert_no_offenses(<<~RUBY, 'test/api/v2/http_client_test.rb')
      class API::V2::HttpClientTest < Minitest::Test; end
    RUBY
  end

  def test_accepts_test_prefix
    assert_no_offenses(<<~RUBY, 'test/admin/test_employee.rb')
      class Admin::EmployeeTest < Minitest::Test; end
    RUBY
  end

  def test_prefers_test_suffix_when_filename_has_both
    assert_no_offenses(<<~RUBY, 'test/test_case_test.rb')
      class TestCaseTest < Minitest::Test; end
    RUBY
  end

  def test_ignores_standard_type_directories
    %w[models controllers helpers mailers jobs channels integration routing system].each do |directory|
      assert_no_offenses(<<~RUBY, "test/#{directory}/admin/employee_test.rb")
        class Admin::EmployeeTest < ActiveSupport::TestCase; end
      RUBY
    end
  end

  def test_preserves_nested_type_directories
    assert_offense(<<~RUBY, 'test/admin/models/employee_test.rb')
      class Admin::EmployeeTest < Minitest::Test
            ^^^^^^^^^^^^^^^^^^^ Test class name should be `Admin::Models::EmployeeTest` to match its file path.
      end
    RUBY
  end

  def test_preserves_nonstandard_type_directories
    assert_offense(<<~RUBY, 'test/services/employee_test.rb')
      class EmployeeTest < Minitest::Test
            ^^^^^^^^^^^^ Test class name should be `Services::EmployeeTest` to match its file path.
      end
    RUBY
  end

  def test_uses_nearest_test_directory_in_absolute_path
    assert_no_offenses(<<~RUBY, '/project/test/dummy/test/models/admin/employee_test.rb')
      class Admin::EmployeeTest < ActiveSupport::TestCase; end
    RUBY
  end

  def test_accepts_engine_path
    assert_no_offenses(<<~RUBY, 'engines/payroll/test/models/admin/employee_test.rb')
      class Admin::EmployeeTest < ActiveSupport::TestCase; end
    RUBY
  end

  def test_ignores_files_outside_test_directory
    assert_no_offenses(<<~RUBY, 'lib/admin/employee_test.rb')
      class EmployeeTest < Minitest::Test; end
    RUBY
  end

  def test_ignores_test_helper_files
    assert_no_offenses(<<~RUBY, 'test/support/base.rb')
      class BaseTest < Minitest::Test; end
    RUBY
  end

  def test_ignores_non_test_class
    assert_no_offenses(<<~RUBY, 'test/employee_test.rb')
      class Employee < Object; end
    RUBY
  end

  def test_ignores_class_without_superclass
    assert_no_offenses(<<~RUBY, 'test/admin/employee_test.rb')
      class EmployeeTest; end
    RUBY
  end

  def test_ignores_dynamic_namespace
    assert_no_offenses(<<~RUBY, 'test/admin/employee_test.rb')
      class factory::EmployeeTest < Minitest::Test; end
    RUBY
  end

  def test_checks_each_test_class_in_file
    assert_offense(<<~RUBY, 'test/admin/employee_test.rb')
      class Admin::EmployeeTest < Minitest::Test; end
      class EmployeeTest < Minitest::Test
            ^^^^^^^^^^^^ Test class name should be `Admin::EmployeeTest` to match its file path.
      end
    RUBY
  end

  def test_ignores_empty_file
    assert_no_offenses('', 'test/employee_test.rb')
  end
end

class TestClassNameWithCustomIgnoredDirectoriesTest < RuboCop::TestCase
  def test_ignores_custom_directory
    assert_no_offenses(<<~RUBY, 'test/services/admin/employee_test.rb')
      class Admin::EmployeeTest < Minitest::Test; end
    RUBY
  end

  def test_preserves_standard_directories_when_not_configured
    assert_offense(<<~RUBY, 'test/models/employee_test.rb')
      class EmployeeTest < Minitest::Test
            ^^^^^^^^^^^^ Test class name should be `Models::EmployeeTest` to match its file path.
      end
    RUBY
  end

  private

  def cop_class
    RuboCop::Cop::Minitest::TestClassName
  end

  def cop_config
    { 'IgnoredDirectories' => ['services'] }
  end
end

class TestClassNameWithoutIgnoredDirectoriesTest < RuboCop::TestCase
  def test_requires_type_directory_namespace
    assert_offense(<<~RUBY, 'test/models/employee_test.rb')
      class EmployeeTest < Minitest::Test
            ^^^^^^^^^^^^ Test class name should be `Models::EmployeeTest` to match its file path.
      end
    RUBY
  end

  def test_accepts_type_directory_namespace
    assert_no_offenses(<<~RUBY, 'test/models/employee_test.rb')
      class Models::EmployeeTest < Minitest::Test; end
    RUBY
  end

  private

  def cop_class
    RuboCop::Cop::Minitest::TestClassName
  end

  def cop_config
    { 'IgnoredDirectories' => [] }
  end
end
