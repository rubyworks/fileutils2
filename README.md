# FileUtils2

*A Refeactorization of Ruby's FileUtils Standard Library*

[Homepage](http://rubyworks.github.com/fileutils2) /
[Documentation](http://rubydoc.info/gems/fileutils2) /
[Report Issue](http://github.com/rubyworks/fileutils2/issues) /
[Source Code](http://github.com/rubyworks/fileutils2)

[![Gem Version](https://badge.fury.io/rb/fileutils2.png)](http://badge.fury.io/rb/fileutils2)
[![Build Status](https://secure.travis-ci.org/rubyworks/fileutils2.png)](http://travis-ci.org/rubyworks/fileutils2) &nbsp; &nbsp;
[![Flattr Me](http://api.flattr.com/button/flattr-badge-large.png)](http://flattr.com/thing/324911/Rubyworks-Ruby-Development-Fund)


## About

FileUtils as provided in Ruby sufferes from the following design flaws:

1. By using `module_function` FileUtils creates two copies of every method.
   Overridding an instance method will not override the correspoonding class
   method, and vice-versa.

2. The design makes it inordinately more difficult to properly extend 
   FileUtils than it needs to be, because one has to manually ensure any
   new methods to Fileutisl are also added to all FileUtils submodules.

3. The meta-programming aspec of the design requires the direct modification
   of a constant, `OPT_TABLE`.

4. Ruby's Module Inclusion Problem prevent extension modules form being included
   into FileUtils without additional steps being take to include the module
   in every submodule as well.

Lets take a simple example. Lets say we want to add a recursive linking
method. 

    module FileUtils
      def ln_r(dir, dest, options={})
        ...
      end
      module_function :ln_r
    end

That would seem like the right code, would it not? Unforunately you would be
way off the mark. Instead one would need to do the following:

    module FileUtils
      OPT_TABLE['ln_r'] = [:force, :noop, :verbose]

      def ln_r(dir, dest, options={})
        fu_check_options options, OPT_TABLE['ln_r']
        ...
      end
      module_function :ln_r

      [Verbose, NoWrite, DryRun].each do |submodule|
        submodule.module_eval do
          include FileUtils
          ::FileUtils.collect_method(:verbose).each do |name|
            module_eval(<<-EOS, __FILE__, __LINE__ + 1)
              def #{name}(*args)
                super(*fu_update_option(args, :verbose => true))
              end
              private :#{name}
            EOS
          end
          extend self
        end
      end
    end

FileUtils2 fixes all this by doing three thing:

1. Use `self extend` instead of `module_function`.
2. Overriding `#include` to ensure inclusion at all levels.
3. Define a single *smart* DSL method called, #define_command`.

With these changes the above code becomes simply:

    module FileUtils
      def ln_r(dir, dest, options={})
        fu_check_options options, OPT_TABLE['ln_r']
        ...
      end

      define_command('ln_r', :force, :noop, :verbose)
    end

Notice we still have to check the `OPT_TABLE` for supported options. So
there is still room for some improvement in the design. This "second phase"
will come later, after the initial phase has been put through the pacses.
At least, that was the plan.

Also note that this refactorization does not chanage the underlying functionality
or the FileUtils methods in any way. They remain the same as in Ruby standard
library.


## Why a Gem?

You might be wondering why this is a Gem and not part of Ruby's standard library.
Unfortunatel, due to to what I beleive to be nothing more than "clique politics"
among some of the  Ruby Core members, this code has been rejected.

Actually it was accepted, but after the discovery a bug (easily fixed) it was
reverted. Despite the code passing all tests, and the fact that this bug made it
clear that the tests themselves were missing something (that's a good thing to 
discover!), the code was reverted to the old design. Sadly, I am certain there
was no other reason for it than the simple fact that the three main core members
from Seattle.rb begrude me, and go out ther way to undermine everything I do.
This behavior is farily well documented in the archives of the ruby-talk mailing
list. I don't like to think that their personal opinions of me would influence
the design of the Ruby programming language, which should be of the upmost
professional character, but it is clearly not the case, as is evidenced by
the fact that they were not willing to discuss the design, let alone actuall fix
it, but instead summarily decalared themselves the new maintainers of the code,
reverted the code to the old design and pronounced the issue closed. Period.


## Legal

Copyright (c) 2011 Rubyworks

Copyright (c) 2000 Minero Aoki

This program is distributed under the terms of the
[BSD-2-Clause](http://www.spdx.org/licenses/BSD-2-Clause) license.

See LICNESE.txt file for details.

