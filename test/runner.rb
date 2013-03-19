if defined?(::FileUtils)
  warn "WARNING! Original FileUtils library is already loaded!"
end

root = File.expand_path('..', File.dirname(__FILE__))

$LOAD_PATH.unshift(File.join(root, 'test'))
$LOAD_PATH.unshift(File.join(root, 'lib'))

require 'minitest/autorun'

test_files = Dir[File.join(root, 'test', 'fileutils2', 'test_*.rb')] 
test_files.each do |test_file|
  require test_file
end

