class Package < ApplicationRecord
  belongs_to :user
  has_one :notification
end
