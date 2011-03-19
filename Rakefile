require "rubygems"
require "bundler/setup"
require File.expand_path('../dragnet-training', __FILE__)

desc "feed default pages into redis through Ohm"
task :pages do
  Page.all.each { |p| p.delete }
  %w(http://mathish.com http://www.reddit.com/r/ruby/).each do |site|
    Page.create :name => site, :html => Typhoeus::Request.get(site).body
  end
end
