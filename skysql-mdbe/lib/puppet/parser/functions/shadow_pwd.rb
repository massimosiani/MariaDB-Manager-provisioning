#!/usr/bin/ruby
require 'digest/sha2'

module Puppet::Parser::Functions
	newfunction(:shadow_pwd, :type => :rvalue) do |args|
		pwd = args[0]
		salt = args[1]
		shadow_pwd = pwd.crypt(salt)
		shadow_pwd
	end
end
