require 'ohm'

Ohm.connect

class Page < Ohm::Model
  attribute :name
  attribute :html
  list :blocks, BlockContent
  
  index :name
  
  def validate
    assert_present  :name
    assert_unique   :name
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
end

class BlockContent < Ohm::Model
  attribute :element
  attribute :id_name
  attribute :class_name
  attribute :content
  
  index :element
  index :id_name
  index :class_name
  index :content
end

def count_unique_blocks(blocks = [], element_name = nil)
  count = Hash.new { |hash, key| hash[key] = 0 }
  blocks.each { |block| count[block.element.to_sym] += 1 }
  count
end

count = count_unique_blocks(Page[1].blocks)