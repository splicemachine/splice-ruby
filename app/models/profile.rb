class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :address, as: :addressable
  has_and_belongs_to_many :tags
end
