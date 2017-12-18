#!/usr/bin/env ruby

$:.unshift File.expand_path("../../vendor/cli-ui/lib", __FILE__)

require 'cli/ui'
require 'fileutils'
require 'net/http'
require 'uri'

require_relative 'runner'
