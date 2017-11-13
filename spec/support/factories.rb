# frozen_string_literal: true
require "factory_girl"

Dir["#{File.dirname(__FILE__)}/factories/**.rb"].each do |f|
  require File.expand_path(f)
end
