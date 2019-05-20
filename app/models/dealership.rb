class Dealership < ActiveRecord::Base
  has_many :users
  has_many :customers
  has_many :vehicles
end
