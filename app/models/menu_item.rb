class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item

  validate :validate_price

  private

  def validate_price
    errors.add(:price, "should be at least 0.01") if price.nil? || price < 0.01
  end
end
