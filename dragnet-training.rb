# -*- encoding: utf-8 -*-
require "rubygems"
require "bundler/setup"
require 'ohm'
require 'typhoeus'
require 'classifier'
require 'nokogiri'

class Page < Ohm::Model
  attribute :name
  attribute :html
  list :blocks, BlockContent
  
  index :name
  
  def validate
    assert_present :name
  end
  
  def parse_block_content
    self.blocks.clear
    doc = Nokogiri::HTML(self.html)
    doc.css('body *').each do |child|
      self.blocks << BlockContent.create(:element => child.name,
        :id_name => child['id'], :class_name => child['class'],
        :content => child.content)
    end
  end
  
  def relevant_blocks(score=0.3)
    @relevant_blocks ||= self.blocks.select do |b|
      b.content_score.to_f >= score
    end
  end
  
  def cleansed_content
    Nokogiri::HTML(self.html).css('body').first.content.to_s.split(/\s+/).join(' ').strip
  end
end

class BlockContent < Ohm::Model
  attribute :element
  attribute :id_name
  attribute :class_name
  attribute :content
  attribute :classification
  attribute :content_score
  
  def pretty_name
    name = "[#{self.id}] #{self.element}"
    name << "##{self.id_name}" unless self.id_name.nil? || self.id_name.empty?
    name << ".\"#{self.class_name}\"" unless self.class_name.nil? || self.class_name.empty?
    name
  end
  
  def cleansed_content
    self.content.to_s.split(/\s+/).join(' ').strip
  end
end

class ContentScore
  def initialize content
    @content = content.split(/\s+/).join(' ').strip
    @clength = @content.size * 1.0
  end
  
  def rate other
    inter = @content[other] || ''
    inter.size / @clength
  end
end
