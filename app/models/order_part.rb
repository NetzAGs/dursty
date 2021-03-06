class OrderPart < ActiveRecord::Base
  attr_accessible :amount, :id, :shop_bundle_id, :order_id, :positive, :name
  belongs_to :order
  belongs_to :shop_bundle
  has_many :order_part_items
  has_many :items, :through => :order_part_items

  def removePartItems
    return self.order_part_items.destroy_all
  end

  def sumOfPartItems
    sum = 0
    self.order_part_items.each do |i|
      sum += i.amount * i.price
    end

    sum = sum*(-1) unless self.positive

    return sum
  end


  def inventory
    inv = Hash.new(0)
    self.order_part_items.each do |pi|
      pi.inventory.each do |item,amount|
        # count negative for outgoing and positive for incoming items
        amount *= (-1) if self.positive

        inv[item] += amount
      end
    end
    return inv
  end

  def updateBundleAmount shop_bundle_id, amount
    ShopBundle.find(shop_bundle_id).shop_bundle_parts.each do |p|
      part_item = self.order_part_items.where(:item_id => p.item_id)
                    .first_or_create!(:order_part_id => self.id, :item_id => p.item_id, :amount => 0,
                                      :price => p.item_price.price, :name => p.item.name)
      if part_item.amount + (amount.to_i * p.amount) > 0
        part_item.amount += (amount.to_i * p.amount)
      else
        part_item.amount = 0
      end
      return false unless part_item.save
    end
    return true
  end

  def updateItem item_id, amount
    item = self.order_part_items.find(item_id)
    if item.amount + amount.to_i > 0
      item.amount += amount.to_i
    else
      item.amount = 0
    end
    return item.save
  end

  def soldItems
    res = Hash.new(0)
    self.order_part_items.each do |pi|
      res[pi.item] += pi.amount
    end
    return res
  end
end
