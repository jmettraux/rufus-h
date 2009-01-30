
#
# Specifying rufus-h
#
# Fri Jan 30 13:51:32 JST 2009
#

%w{ lib test }.each do |path|
  path = File.expand_path(File.dirname(__FILE__) + '/../' + path)
  $: << path unless $:.include?(path)
end

require 'rubygems'
require 'bacon'

Bacon.summary_on_exit

require 'rufus/h'

