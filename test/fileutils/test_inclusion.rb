require 'fileutils'
require 'test/unit'

class TestFileUtilsInclusion < Test::Unit::TestCase

  module Foo
    def foo?; true; end
  end

  def test_include_into_all_submodules
    ::FileUtils.send(:include, Foo)

    assert_include ::FileUtils.ancestors, Foo
    assert_include ::FileUtils::NoWrite.ancestors, Foo
    assert_include ::FileUtils::Verbose.ancestors, Foo
    assert_include ::FileUtils::DryRun.ancestors, Foo

    assert ::FileUtils::NoWrite.foo?
    assert ::FileUtils::Verbose.foo?
    assert ::FileUtils::DryRun.foo?
    assert ::FileUtils.foo?
  end

  def test_includes_streamutils
    assert_include(::FileUtils::Verbose.private_instance_methods(true), :fu_stream_blksize)
  end

end
