require 'fileutils2'
require 'test/unit'

class TestFileUtils2Inclusion < Test::Unit::TestCase

  module Foo
    def foo?; true; end
  end

  def test_include_into_all_submodules
    ::FileUtils2.send(:include, Foo)

    assert_includes ::FileUtils2.ancestors, Foo
    assert_includes ::FileUtils2::NoWrite.ancestors, Foo
    assert_includes ::FileUtils2::Verbose.ancestors, Foo
    assert_includes ::FileUtils2::DryRun.ancestors, Foo

    assert ::FileUtils2::NoWrite.foo?
    assert ::FileUtils2::Verbose.foo?
    assert ::FileUtils2::DryRun.foo?
    assert ::FileUtils2.foo?
  end

end
