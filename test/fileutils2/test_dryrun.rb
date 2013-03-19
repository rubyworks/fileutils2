# $Id$

require 'fileutils'
require 'fileutils/visibility_tests'
require 'fileutils/clobber'
require 'test/unit'

class TestFileUtilsDryRun < Test::Unit::TestCase

  include FileUtils::DryRun
  include TestFileUtils::Clobber
  include TestFileUtils::Visibility

  def setup
    super
    @fu_module = FileUtils::DryRun
  end

end
