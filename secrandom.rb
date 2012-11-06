#!/usr/bin/env ruby

require 'securerandom'


# I'd like to run some speed tests using the different ways to generate the
# string data.  For example, how long to generate a given set of strings using
# the "charset" method below vs. urlsafe / substitution method.
# We can also brainstorm on other ways to get the strings we want.


# SecureRandom.random_number generates 0.<numbers>
# Generate floating point, convert to string, strip off the lead '0.', and get
# the number back.
result = SecureRandom.random_number.to_s.gsub('0.', '').to_i
puts "random_number, fuzzy length => #{result}"
# It works, but it's nasty and we can't control the length. :(


# We can specify character sets to be used.
set = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
result = Array.new(32){set[SecureRandom.random_number(set.length)]}.join
puts "[a-zA-Z0-9], length 32 => #{result}"

set = '23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ'
result = Array.new(12){set[SecureRandom.random_number(set.length)]}.join
puts "[a-zA-Z0-9] except confusing chars, length 12 => #{result}"


# SecureRandom.hex will generate set [a-f0-9] for us.
result = SecureRandom.hex(8)
puts "hex, length 8 => #{result}"


# SecureRandom.base64 will generate set [a-zA-Z0-9\+\/\=]; this is sort of
# useful, but the weird characters are irritating...
result = SecureRandom.base64
puts "base64, fuzzy length => #{result}"


# urlsafe gives us *almost* [a-zA-Z0-9], but also sometimes - and _. :(
result = SecureRandom.urlsafe_base64
puts "urlsafe_base64, fuzzy length => #{result}"
# So we can substitute a random number for the "other" char. :P
sub = SecureRandom.random_number(10).to_s
result.gsub!(/[\-\_]/, sub)
puts "urlsafe_base64, fuzzy length, alphanum only => #{result}"
# Yes, this works, but it's hacky as hell, haha.
