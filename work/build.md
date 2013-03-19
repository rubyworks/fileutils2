## Build Status

This is failing b/c Travis CI is pre-loading fileutils.rb. Unless that can be fixed, then there
is no way to propery fest FileUtils2 on Travis CI as is.

[![Build Status](https://secure.travis-ci.org/rubyworks/fileutils2.png)](http://travis-ci.org/rubyworks/fileutils2)

I could rename the module to FileUtils2, set FileUtils = FileUtils2 and then change all the tests to use FileUtils2 instead of FileUtils. That should work, but I am not sure it is a good idea to maintain all these references changes to the tests --I'd rather they reflect the original tests as much as possible.


