class Company < ActiveRecord::Base
  include Scopeable

  has_many :users, dependent: :destroy
  has_many :profiles, through: :users
  has_one :address, as: :addressable

  validates :name, presence: true

  attr_readonly :description

  scope :grouped, -> { group :name }

  def total_profile_views
    profiles.sum(:views)
  end

  def average_profile_views
    profiles.average(:views)
  end
end
