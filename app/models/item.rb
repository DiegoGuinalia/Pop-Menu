class Item < ApplicationRecord
  has_many :menu_items

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
end
