# $Id$

require 'fileutils2'
require 'fileutils2/visibility_tests'
require 'fileutils2/clobber'
require 'test/unit'

class TestFileUtils2NoWrite < Test::Unit::TestCase

  include FileUtils2::NoWrite
  include TestFileUtils2::Visibility
  include TestFileUtils2::Clobber

  def setup
    super
    @fu_module = FileUtils2::NoWrite
  end

end
