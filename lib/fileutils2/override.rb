require 'fileutils2'

verbose = $VERBOSE
begin
  $VERBOSE = false
  FileUtils = ::FileUtils2
ensure
  $VERBOSE = verbose
end

