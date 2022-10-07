class Client < ApplicationRecord
  validates :name, presence: true
  validates :phone, presence: true
  validates :last_purchase, presence: true
end
