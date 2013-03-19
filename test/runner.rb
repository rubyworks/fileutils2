begin
  FileUtils
  raise "FileUtils is already loaded!"
rescue
end

require 'minitest/autorun'

root = File.expand_path('..', File.dirname(__FILE__))

$LOAD_PATH.unshift(File.join(root, 'lib'))

test_files = Dir[File.join(root, 'test', 'fileutils', 'test_*.rb')] 

test_files.each do |test_file|
  require test_file
end

