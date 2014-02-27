#!/usr/bin/ruby
require 'digest/sha2'

pwd = ARGV[0]
salt = ARGV[1]
shadow_pwd = pwd.crypt(salt)
puts shadow_pwd
