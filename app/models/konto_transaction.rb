class KontoTransaction < ActiveRecord::Base
  attr_accessible :name, :from, :to, :price
  validates_presence_of :from, :to, :name, :price

  belongs_to :from_konto, :class_name => "Konto", :foreign_key => :from
  belongs_to :to_konto, :class_name => "Konto", :foreign_key => :to

end
