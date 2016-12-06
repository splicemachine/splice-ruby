module Scopeable
  extend ActiveSupport::Concern

  included do
    scope :all_records, -> { where.not(id: nil) }
    scope :ordered, -> { order id: :desc }
    scope :reverse_ordered, -> { order(id: :desc).reverse_order }
    scope :limited, -> { limit 1 }
    scope :selected, -> { select :id }
    scope :offsetted, -> { offset 1 }
  end
end
