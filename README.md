# FileUtils2

*A Refactorization of Ruby's Standard FileUtils Library*

[Homepage](http://rubyworks.github.com/fileutils2) /
[Documentation](http://rubydoc.info/gems/fileutils2) /
[Report Issue](http://github.com/rubyworks/fileutils2/issues) /
[Source Code](http://github.com/rubyworks/fileutils2)

[![Build Status](https://secure.travis-ci.org/rubyworks/fileutils2.png)](http://travis-ci.org/rubyworks/fileutils2)
[![Gem Version](https://badge.fury.io/rb/fileutils2.png)](http://badge.fury.io/rb/fileutils2) &nbsp; &nbsp;
[![Flattr Me](http://api.flattr.com/button/flattr-badge-large.png)](http://flattr.com/thing/324911/Rubyworks-Ruby-Development-Fund)


## About

FileUtils as provided in Ruby suffers from the following design issues:

1. By using `module_function` FileUtils creates two copies of every method.
   Overriding an instance method will not override the corresponding class
   method, and vice-versa.

2. The design makes it inordinately more difficult to properly extend 
   FileUtils than it needs to be, because one has to manually ensure any
   new method added to FileUtils are also added to the submodules.

3. The meta-programming aspect of the design requires the direct modification
   of a constant, `OPT_TABLE`.

4. Ruby's Module Inclusion Problem prevents extension modules from being included
   into FileUtils without additional steps being taken to include the module
   in every submodule as well.

Lets take a simple example. Lets say we want to add a recursive linking
method. 

```ruby
    module FileUtils
      def ln_r(dir, dest, options={})
        ...
      end
      module_function :ln_r
  end
```

That would seem like the right code, would it not? Unfortunately you would be
way off the mark. Instead one would need to do the following:

```ruby
    module FileUtils
      OPT_TABLE['ln_r'] = [:force, :noop, :verbose]

      def ln_r(dir, dest, options={})
        fu_check_options options, OPT_TABLE['ln_r']
        ...
      end
      module_function :ln_r

      module Verbose
        include FileUtils
        module_eval(<<-EOS, __FILE__, __LINE__ + 1)
          def ln_r(*args)
            super(*fu_update_option(args, :verbose => true))
          end
          private :ln_r
        EOS
        extend self
      end

      module NoWrite
        include FileUtils
        module_eval(<<-EOS, __FILE__, __LINE__ + 1)
          def ln_r(*args)
            super(*fu_update_option(args, :noop => true))
          end
          private :ln_r
        EOS
        extend self
      end

      module DryRun
        include FileUtils
        module_eval(<<-EOS, __FILE__, __LINE__ + 1)
          def ln_r(*args)
            super(*fu_update_option(args, :noop => true, :verbose => true))
          end
          private :ln_r
        EOS
        extend self
      end
    end
```

FileUtils2 fixes all this by doing three thing:

1. Use `self extend` instead of `module_function`.
2. Overriding `#include` to ensure inclusion at all levels.
3. Define a single *smart* DSL method called, #define_command`.

With these changes the above code becomes simply:

```ruby
    module FileUtils2
      def ln_r(dir, dest, options={})
        fu_check_options options, OPT_TABLE['ln_r']
        ...
      end

      define_command('ln_r', :force, :noop, :verbose)
    end
```

Notice we still check the `OPT_TABLE` to ensure only the supported options
are provided. So there is still room for some improvement in the design.
This "second phase" will come later, after the initial phase has been put 
through its paces. (At least, that was the plan. See "Why a Gem" below.)

Also note that this refactorization does not change the underlying functionality
or the FileUtils methods in any way. They remain the same as in Ruby's standard
library.


## Overriding FileUtils

You can use FileUtils2 in place of FileUtils simple by setting FileUtils
equal to FileUtils2.

```ruby
    require 'fileutils2'
    FileUtils = FileUtils2
```

It will issue a warning if FileUtils is already loaded, but it should work fine
in either case. In fact, it may be wise to first `require 'fileutils'` in anycase
to make sure it's not loaded later by some other script, which could cause some
unspecified results due to method clobbering. Of course there should plenty
of warnings in the output in that case, so you could just keep an eye out for
it instead.

For the sake of simply being overly thurough, included in the gem is a script
that takes care of most of this for you called, `override.rb`.

```ruby
    require 'fileutils2/override'
```

It requires fileutils2.rb for you and sets `FileUtils = FileUtils2` while
supressing the usual warning. It doesn't preload the old fileutils.rb library
first though. That's your call.


## JRuby and Rubinius Users

FileUtils2, as well as the original FileUtils library for that matter, produce
a few test failures (out of a 1000+) when run again JRuby or Rubinius. At this
point it is unclear exactly what the issues are. If you are involved in either
of these projects and can spare a little time to try and fix these issues, that
would be really great of you! Have a look at the
[Rubinius build](https://travis-ci.org/rubyworks/fileutils2/jobs/5634466)
and the [JRuby build](https://travis-ci.org/rubyworks/fileutils2/jobs/5634467)
for these test results.


## Why a Gem?

You might be wondering why this is a Gem and not part of Ruby's standard library.
Unfortunately, due to to what I believe to be nothing more than "clique politics"
among some of the  Ruby Core members, this code has been rejected.

Actually it was accepted, but after the discovery a bug (easily fixed) it was
reverted. Despite the code passing all tests, and the fact that this bug made it
clear that the tests themselves were missing something (that's a good thing to 
discover!), the code was reverted to the old design. Sadly, I am certain there
was no other reason for it than the simple fact that the three main core members
from Seattle.rb begrudge me, and go out their way to undermine everything I do.
This behavior is fairly well documented in the archives of the ruby-talk mailing
list. I don't like to think that their personal opinions of me would influence
the design of the Ruby programming language, which should be of the utmost
professional character, but it is clearly not the case, as is evidenced by
the fact that they were not willing to discuss the design, let alone actually fix
it, but instead summarily declared themselves the new maintainers of the code,
reverted the code to the old design and pronounced the issue closed. Period.

* https://bugs.ruby-lang.org/issues/4970
* https://bugs.ruby-lang.org/issues/7958


## Legal

Copyright (c) 2011 Rubyworks

Copyright (c) 2000 Minero Aoki

This program is distributed under the terms of the
[BSD-2-Clause](http://www.spdx.org/licenses/BSD-2-Clause) license.

See LICENSE.txt file for details.

