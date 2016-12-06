class User < ActiveRecord::Base
  belongs_to :company
  has_one :profile, dependent: :destroy
  has_one :address, through: :profile

  scope :grouped, -> { group :email }
  scope :having_grouped, -> { grouped.having("sum(credit) > ?", 0) }

  validates :company, presence: true
end
