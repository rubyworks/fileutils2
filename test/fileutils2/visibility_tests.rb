require 'fileutils2'
require 'test/unit'

class TestFileUtils2 < Test::Unit::TestCase
end

##
# These tests are reused in the FileUtils::Verbose, FileUtils::NoWrite and
# FileUtils::DryRun tests
#
module TestFileUtils2::Visibility

  FileUtils2::METHODS.each do |m|
    define_method "test_singleton_visibility_#{m}" do
      assert @fu_module.respond_to?(m, true),
             "#{@fu_module}.#{m} is not defined"
      assert @fu_module.respond_to?(m, false),
             "#{@fu_module}.#{m} is not public"
    end

    define_method "test_visibility_#{m}" do
      assert respond_to?(m, true),
             "#{@fu_module}\##{m} is not defined"
      assert @fu_module.private_method_defined?(m),
             "#{@fu_module}\##{m} is not private"
    end
  end

  FileUtils2::StreamUtils_.private_instance_methods.each do |m|
    define_method "test_singleton_visibility_#{m}" do
      assert @fu_module.respond_to?(m, true),
             "#{@fu_module}\##{m} is not defined"
    end

    define_method "test_visibility_#{m}" do
      assert respond_to?(m, true),
             "#{@fu_module}\##{m} is not defined"
    end
  end

end
