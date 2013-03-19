# $Id$

require 'fileutils'
require 'fileutils/visibility_tests'
require 'fileutils/clobber'
require 'test/unit'

class TestFileUtilsNoWrite < Test::Unit::TestCase

  include FileUtils::NoWrite
  include TestFileUtils::Visibility
  include TestFileUtils::Clobber

  def setup
    super
    @fu_module = FileUtils::NoWrite
  end

end
