# -*- encoding: utf-8 -*-

require 'ohm'
require 'typhoeus'
require 'classifier'

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
  end
end

class BlockContent < Ohm::Model
  attribute :element
  attribute :id_name
  attribute :class_name
  attribute :content
end
