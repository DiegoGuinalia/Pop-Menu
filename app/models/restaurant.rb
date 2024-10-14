class Restaurant < ApplicationRecord
  has_many :menus

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
end
