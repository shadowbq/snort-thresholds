require 'rubygems'
require 'forwardable' # Needed by veto
require 'veto'

module Threshold
  $:.unshift(File.dirname(__FILE__))

  #require library
  require 'threshold/suppression'
  require 'threshold/event_filter'
  require 'threshold/suppressions'
  require 'threshold/rate_filter'
end