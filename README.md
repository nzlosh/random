nzlosh/random
=============

This is a sandbox for some ideas that we're throwing around. Feel free to
document those ideas here. :)

raas.rb
-------

So the API can deal with this : `/:enc/:charset/:len/:num`

 * Valid `:enc` are `p`, `j`, `y`, `h`, and `x`.
 * Valid `:charset` are `ab`, `as`, `hex`, and `num`.
 * `:len` is length of each result.
 * `:num` is the number of results.

Run it like this : `$ ruby ./raas.rb`

random
------

Various random data generator classes.

  * RandomGenerator (Base class)
  * AsciiGenerator
  * SafeAsciiGenerator
  * WordGenerator
  * NumberGenerator

A class accepts constraints as to the minimum and maximum range to generate,
the count presents the sample size of the data to generate.

Each class is responsible for formatting it's resulting data set.

