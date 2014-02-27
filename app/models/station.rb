class Station < ActiveRecord::Base
  has_many :measurements
end
