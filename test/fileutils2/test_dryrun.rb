# $Id$

require 'fileutils2'
require 'fileutils2/visibility_tests'
require 'fileutils2/clobber'
require 'test/unit'

class TestFileUtils2DryRun < Test::Unit::TestCase

  include FileUtils2::DryRun
  include TestFileUtils2::Clobber
  include TestFileUtils2::Visibility

  def setup
    super
    @fu_module = FileUtils2::DryRun
  end

end
