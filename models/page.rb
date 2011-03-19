# -*- encoding: utf-8 -*-

class Page < Ohm::Model
  attribute :name
  attribute :html
  
  index :name
  
  def validate
    assert_present :name
  end
end
