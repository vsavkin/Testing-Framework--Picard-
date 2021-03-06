## Now, let’s take a look at a test using Picard

    require 'picard'

    class DemoTest < Test::Unit::TestCase
	    include Picard::TestUnit

	    def test_simple_math
  	    given
    	    x = 1
    	    y = 2

  	    expect
    	    x + y == 3
	    end
    end

To start using picard you need to mix in Picard::TestUnit module into your TestUnit test case.  It will add a special hook that will transform every test method in your test case. For instance, the "test_simple_math" method will be transformed into something like:

    def test_simple_math
      given
        x = 1
        y = 2
      
      expect
        assert_equal 3, (x + y), MESSAGE
      end
    end


Where the MESSAGE is:

  --------------------------------------------------------------------------------------
  | File: "/Users/savkin/projects/picard/test/picard/demo_test.rb", Line: 10           |
  | Failed Assertion: (x + y == 3)                                    	               |
  --------------------------------------------------------------------------------------


You might notice a few things here:
1. Picard uses TestUnit, so all your tools we will work with it just fine.
2. Picard is smart enough to insert assert_equal instead of regular assert.
3. Picard generates a very descriptive error message containing not only the file name and the line number of the failed assertion but the assertion itself. In most cases it’s enough information to understand what went wrong so you won't have to find that exact line number to figure it out.


## What if I want to try?

    gem 'picard'


## What is coming next?

There are some things I'm going to add in a week or two:

1. The only special case Picard supports right now is `==`. If you are using something like `x != y` in your `expect` block it will just insert a regular `assert` which is bad. It's going to be much smarter than this soon.
2.
In Spock it's possible to write data driven tests:
 
    expect:
    x + y == z
    
    where:
    x = [1, 10, 100]
    y = [2, 20, 200]
    z = [3, 30, 300]

Basically it will transform into something like:

    expect:
    1 + 2 == 3
    10 + 20 == 30
    100 + 200 == 300

Which is totally awesome! I'm going to add a similar feature to Picard soon.

3. Right now Picard is written in Ruby 1.9 but it can parse only 1.8 syntax (which is weird). It needs to be put in order so it will work properly on 1.8 and 1.9.
