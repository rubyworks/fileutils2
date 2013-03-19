require 'fileutils'
require 'test/unit'

class TestFileUtilsInclusion < Test::Unit::TestCase

  module Foo
    def foo?; true; end
  end

  def test_include_into_all_submodules
    ::FileUtils.send(:include, Foo)

    assert ::FileUtils.ancestors.include?(Foo)
    assert ::FileUtils::NoWrite.ancestors.include?(Foo)
    assert ::FileUtils::Verbose.ancestors.include?(Foo)
    assert ::FileUtils::DryRun.ancestors.include?(Foo)

    assert ::FileUtils::NoWrite.foo?
    assert ::FileUtils::Verbose.foo?
    assert ::FileUtils::DryRun.foo?
    assert ::FileUtils.foo?
  end

  def test_includes_streamutils
    assert_include(::FileUtils::Verbose.private_instance_methods(true), :fu_stream_blksize)
  end

end
