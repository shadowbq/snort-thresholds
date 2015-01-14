require 'rubygems'
require 'forwardable' # Needed by veto
require 'veto'
require 'colored'

module Threshold
  $:.unshift(File.dirname(__FILE__))
  require 'threshold/suppression'
end