# $Id$

require 'fileutils'
require 'fileutils/visibility_tests'
require 'test/unit'

class TestFileUtilsVerbose < Test::Unit::TestCase

  include FileUtils::Verbose
  include TestFileUtils::Visibility

  def setup
    super
    @fu_module = FileUtils::Verbose
  end

end
