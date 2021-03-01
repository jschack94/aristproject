class Device < ApplicationRecord

  has_many :heartbeats
  has_many :reports
  validates :phone_number, phone: true

end
