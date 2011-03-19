require File.expand_path('../dragnet-training', __FILE__)
CORPUS_PAGES = %w(http://mathish.com)
#CORPUS_PAGES = %w(http://mathish.com http://www.reddit.com/r/ruby/)


namespace :load do
  desc "feed default pages into redis through Ohm"
  task :pages do
    Page.all.each { |p| p.delete }
    CORPUS_PAGES.each do |site|
      puts "Creating page object: #{site}"
      page = Page.create :name => site, :html => Typhoeus::Request.get(site).body
      puts "Parsing block content"
      page.parse_block_content
      mkdir_p File.expand_path("../expected_bodies", __FILE__)
      puts "Creating sample expected body: #{page.id}.html (you need to modify this to reflect your expectations)"
      File.open(File.expand_path("../expected_bodies/#{page.id}", __FILE__), "w") do |f|
        f.write page.html
      end
    end
  end
end

namespace :show do
  desc "display stored Page objects"
  task :pages do
    Page.all.each do |p|
      puts "-"*50
      puts "name\t: #{p.name}"
      puts "length\t: #{p.html.size}"
      puts "blocks\t: #{p.blocks.size}"
      puts "relev\t: #{p.relevant_blocks.size}"
      puts "-"*30
      p.relevant_blocks.each do |b|
        puts "#{b.pretty_name} => '#{b.content_score}'"
      end
      puts "-"*50
    end
  end
end

namespace :classify do
  desc "classifies block content elements based upon their proximity to the expected body"
  task :pages do
    Page.all.each do |p|
      expected_file = File.expand_path("../expected_bodies/#{p.id}", __FILE__)
      next unless File.exists? expected_file
      scorer = ContentScore.new(File.read(expected_file))
      p.blocks.each do |b|
        b.content_score = scorer.rate b.cleansed_content
        b.save
        puts "#{b.pretty_name} => #{b.content_score}"
      end
    end
  end
end
