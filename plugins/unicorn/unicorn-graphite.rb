#!/usr/bin/env ruby
#
# Check exhaustion of unicorn processes
# ===
#

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'net/http'

class CheckUnicornExhaustion < Sensu::Plugin::Metric::CLI::Graphite

  option :scheme,
         :description => "Metric naming scheme, text to prepend to metric",
         :short => "-s SCHEME",
         :long => "--scheme SCHEME",
         :default => "#{Socket.gethostname}.unicorn"

  def run
    response = Net::HTTP.get('127.0.0.1', '/_raindrops')
    calling, writing, active, queued = response.split("\n").map { |line| line.split(":").last.to_i }

    output "#{config[:scheme]}.general.calling", calling
    output "#{config[:scheme]}.general.writing", writing
    output "#{config[:scheme]}.general.active", active
    output "#{config[:scheme]}.general.queued", queued
    ok
  end
end
