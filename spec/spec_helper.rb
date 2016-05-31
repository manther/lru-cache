#
# ***********************************************************
#  Copyright (c) 2014-2015 VMware, Inc.  All rights reserved.
# ***********************************************************
#

$libdir = File.dirname(File.expand_path(__FILE__)).sub(/spec$/, '')
$LOAD_PATH << $libdir unless $LOAD_PATH.include? $libdir

require 'simplecov'
require 'simplecov-rcov'

class SimpleCov::Formatter::MergedFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    SimpleCov::Formatter::RcovFormatter.new.format(result)
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter

SimpleCov.start do
  coverage_dir 'spec/coverage'
  add_filter 'spec'
  add_filter 'vendor'
end