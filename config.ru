#!/usr/bin/env rackup
# encoding: utf-8

require File.expand_path("../binx_widget.rb", __FILE__)

run Rack::URLMap.new({"/" => BinxWidget})
