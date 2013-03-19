# $Id$

require 'fileutils2'
require 'fileutils2/visibility_tests'
require 'test/unit'

class TestFileUtils2Verbose < Test::Unit::TestCase

  include FileUtils2::Verbose
  include TestFileUtils2::Visibility

  def setup
    super
    @fu_module = FileUtils2::Verbose
  end

end
